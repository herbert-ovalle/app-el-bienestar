package com.example.app_bienestar

import android.os.Bundle
import androidx.annotation.NonNull
import android.content.Context
import android.media.AudioManager
import android.util.Log
import android.net.ConnectivityManager
import android.net.NetworkCapabilities
import android.widget.Toast
import android.net.Uri
import android.content.IntentFilter

import kotlinx.coroutines.suspendCancellableCoroutine
import kotlin.coroutines.resume

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

import io.flutter.embedding.android.FlutterFragmentActivity

import com.example.app_bienestar.NetworkReceiver
import com.example.app_bienestar.RadioOnline

class MainActivity : FlutterFragmentActivity() {
    private val CHANNEL = "com.example.musicplayer/channel"
    private lateinit var networkReceiver: NetworkReceiver
    private var isConnected = true
    private lateinit var radioPlayer: RadioOnline
    private val radioUrl = "https://cloudstream2032.conectarhosting.com/8026/stream" // Reemplaza con la URL de tu radio



    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        radioPlayer = RadioOnline(this)
        radioPlayer.initializePlayer(radioUrl)

        networkReceiver = NetworkReceiver { connected ->
            runOnUiThread {
                isConnected = connected
                Log.d("NetworkReceiver1", "Conexión a Internet: $connected")
                if(!isConnected){
                    radioPlayer.stop()
                }
                Toast.makeText(this, if (connected){ "🌍 Internet disponible"} else {"🌐 Sin conexión"}, Toast.LENGTH_SHORT).show()
            }
        }

        val filter = IntentFilter(ConnectivityManager.CONNECTIVITY_ACTION)
        registerReceiver(networkReceiver, filter)
    }

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "playMusic" -> {

                    if(isConnected){
                        radioPlayer.play()
                        result.success("success")
                        /*val url = "https://cloudstream2032.conectarhosting.com/8026/stream"; 
                        lifecycleScope.launch {
                            try {
                                playMusic(url)
                                result.success("success")
                            } catch (e: Exception) {
                                e.printStackTrace()
                                result.success("error");
                            }
                        }*/

                    }else{
                        result.success("NO_INTERNET")
                        Toast.makeText(this, "🌐 No hay conexión a Internet. Por favor, verifica tu conexión.", Toast.LENGTH_LONG).show()
                    }
                }
                "pauseMusic" -> {
                    radioPlayer.pause()
                    result.success("Paused")
                }
                "stopMusic" -> {
                    radioPlayer.stop()
                    result.success("Stopped")
                }
                "isMusicPlaying" -> {
                    result.success(radioPlayer.isPlaying())
                }
                "ajusteVolumen" -> {
                    val ajuste = call.argument<Int>("ajuste")
                    adjustVolume(ajuste)
                    result.success("Volumen")
                }
                "obtenerVolumen" -> {
                    result.success(radioPlayer.getVolume())
                }
                "estadoInternet" -> {
                    if(isConnected){
                        result.success("online")
                    }else{
                        Toast.makeText(this, "🌐 No hay conexión a Internet. Por favor, verifica tu conexión.", Toast.LENGTH_LONG).show()
                        result.success("offline")
                    }
                }
                else -> result.notImplemented()
            }
        }
    }

    override fun onDestroy() {
        super.onDestroy()
        radioPlayer.stop()
        unregisterReceiver(networkReceiver)
    }

    private fun adjustVolume(percentage: Int?) {
        // Asegura que el porcentaje esté entre 0 y 100
        val clampedPercentage = (percentage ?: 0).coerceIn(0, 100)

        // Convierte el porcentaje a un valor entre 0 y 1
        val newVolume = clampedPercentage / 100f

        radioPlayer.setVolume(newVolume)
        // Asigna el nuevo volumen al ExoPlayer
        //exoPlayer.volume = newVolume

        // Ajusta el volumen general del dispositivo
        val audioManager = getSystemService(Context.AUDIO_SERVICE) as AudioManager
        val maxVolume = audioManager.getStreamMaxVolume(AudioManager.STREAM_MUSIC)
        val deviceVolume = (clampedPercentage * maxVolume) / 100
        audioManager.setStreamVolume(AudioManager.STREAM_MUSIC, deviceVolume, 0)
    }
}

