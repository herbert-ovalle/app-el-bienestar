package com.example.app_bienestar

import android.media.MediaPlayer
import android.os.Bundle
import androidx.annotation.NonNull

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

import android.content.Context
import android.media.AudioManager
import android.util.Log

import com.google.android.exoplayer2.ExoPlayer
import com.google.android.exoplayer2.MediaItem
import com.google.android.exoplayer2.ui.PlayerView
import io.flutter.embedding.android.FlutterFragmentActivity

class MainActivity : FlutterFragmentActivity() {
    private val CHANNEL = "com.example.musicplayer/channel"
    private var mediaPlayer: MediaPlayer? = null
    private var isPlaying = false

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "playMusic" -> {

                    val url = "https://cloudstream2032.conectarhosting.com/8026/stream"; 
                    if (url != null) {
                        playMusic(url)
                        result.success("Playing")
                    } else {
                        result.error("INVALID_URL", "URL is null or invalid", null)
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
    }

    private lateinit var exoPlayer: ExoPlayer
    private fun playMusic(url: String) {

        exoPlayer = ExoPlayer.Builder(this).build()
        val mediaItem = MediaItem.fromUri(url)
        exoPlayer.setMediaItem(mediaItem)
        exoPlayer.prepare() // Preparación asíncrona
        exoPlayer.playWhenReady = true
        exoPlayer.volume = 0.5f
        isPlaying = true
    }

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
