package com.example.app_bienestar

import android.media.MediaPlayer
import android.os.Bundle
import androidx.annotation.NonNull
import android.content.Context
import android.media.AudioManager
import android.util.Log
import android.net.ConnectivityManager
import android.net.NetworkCapabilities
import android.os.Build
import android.widget.Toast
import android.net.Uri

import androidx.lifecycle.lifecycleScope

import kotlinx.coroutines.suspendCancellableCoroutine
import kotlinx.coroutines.launch
import kotlin.coroutines.resume

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

import com.google.android.exoplayer2.ExoPlayer
import com.google.android.exoplayer2.MediaItem
import com.google.android.exoplayer2.ui.PlayerView
import com.google.android.exoplayer2.Player

import io.flutter.embedding.android.FlutterFragmentActivity

import com.example.app_bienestar.NetworkReceiver
import android.content.IntentFilter


class MainActivity : FlutterFragmentActivity() {
    private val CHANNEL = "com.example.musicplayer/channel"
    private var mediaPlayer: MediaPlayer? = null
    private var isPlaying = false
    private lateinit var networkReceiver: NetworkReceiver
    private lateinit var exoPlayer: ExoPlayer
    private var isConnected = false

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        networkReceiver = NetworkReceiver { connected ->
            runOnUiThread {
                isConnected = connected
                if(!isConnected){
                    stopMusic()
                }
                Toast.makeText(this, if (isConnected) "🌍 Internet disponible" else "🌐 Sin conexión", Toast.LENGTH_SHORT).show()
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
                        val url = "https://cloudstream2032.conectarhosting.com/8026/stream"; 
                        if (url != null) {
                            lifecycleScope.launch {
                                try {
                                    playMusic(url)
                                    result.success("success")
                                } catch (e: Exception) {
                                    e.printStackTrace()
                                    result.success("error");
                                }
                            }

                        } else {
                            result.success("INVALID_URL")
                        }
                    }else{
                        result.success("NO_INTERNET")
                        Toast.makeText(this, "🌐 No hay conexión a Internet. Por favor, verifica tu conexión.", Toast.LENGTH_LONG).show()
                    }
                }
                "pauseMusic" -> {
                    pauseMusic()
                    result.success("Paused")
                }
                "stopMusic" -> {
                    stopMusic()
                    result.success("Stopped")
                }
                "isMusicPlaying" -> {
                    result.success(isMusicPlaying())
                }
                "ajusteVolumen" -> {
                    val ajuste = call.argument<Int>("ajuste")
                    adjustVolume(ajuste)
                    result.success("Volumen")
                }
                "obtenerVolumen" -> {
                    result.success(obtenerVolumen())
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

    private fun isMusicPlaying(): Boolean {
        return isPlaying
    }

    override fun onDestroy() {
        super.onDestroy()
        exoPlayer.release()
        unregisterReceiver(networkReceiver)
    }

    private suspend fun playMusic(url: String) {

        exoPlayer = ExoPlayer.Builder(this).build()
        
        val mediaItem = MediaItem.fromUri(Uri.parse(url))
        exoPlayer.setMediaItem(mediaItem)
        
        exoPlayer.prepare()
        
        suspendCancellableCoroutine<Unit> { continuation ->
            val listener = object : Player.Listener {
                override fun onPlaybackStateChanged(state: Int) {
                    if (state == Player.STATE_READY) {
                        exoPlayer.removeListener(this)
                        continuation.resume(Unit)
                    }
                }
            }
            exoPlayer.addListener(listener)
            
            continuation.invokeOnCancellation {
                exoPlayer.removeListener(listener)
                exoPlayer.release()
            }
        }
        
        // Iniciar la reproducción
        exoPlayer.playWhenReady = true
        exoPlayer.volume = 0.5f
        isPlaying = true
    }

    /*private fun playMusic(url: String) {

        exoPlayer = ExoPlayer.Builder(this).build()
        val mediaItem = MediaItem.fromUri(url)
        exoPlayer.setMediaItem(mediaItem)
        exoPlayer.prepare() // Preparación asíncrona
        exoPlayer.playWhenReady = true
        exoPlayer.volume = 0.5f
        isPlaying = true
    }*/

    private fun obtenerVolumen(): Double {
        val audioManager = getSystemService(Context.AUDIO_SERVICE) as AudioManager // Obtener el AudioManager
        val currentVolume = audioManager.getStreamVolume(AudioManager.STREAM_MUSIC) // Volumen actual del stream de música
        val maxVolume = audioManager.getStreamMaxVolume(AudioManager.STREAM_MUSIC) // Volumen máximo del stream de música
        val percentage = (currentVolume.toFloat() / maxVolume.toFloat()).toDouble() // Calcular el porcentaje
        return percentage // Devolver el porcentaje
    }

    private fun pauseMusic() {
        exoPlayer?.pause()
        isPlaying = false
    }

    private fun stopMusic() {
        exoPlayer?.stop()
        exoPlayer?.release()
        isPlaying = false
    }


    private fun adjustVolume(percentage: Int?) {
        // Asegura que el porcentaje esté entre 0 y 100
        val clampedPercentage = (percentage ?: 0).coerceIn(0, 100)

        // Convierte el porcentaje a un valor entre 0 y 1
        val newVolume = clampedPercentage / 100f

        // Asigna el nuevo volumen al ExoPlayer
        exoPlayer.volume = newVolume

        // Ajusta el volumen general del dispositivo
        val audioManager = getSystemService(Context.AUDIO_SERVICE) as AudioManager
        val maxVolume = audioManager.getStreamMaxVolume(AudioManager.STREAM_MUSIC)
        val deviceVolume = (clampedPercentage * maxVolume) / 100
        audioManager.setStreamVolume(AudioManager.STREAM_MUSIC, deviceVolume, 0)
    }
}

