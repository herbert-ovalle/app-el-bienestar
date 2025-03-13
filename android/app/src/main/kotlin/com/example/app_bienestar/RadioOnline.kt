package com.example.app_bienestar

import android.content.Context
import android.net.Uri
import androidx.media3.common.AudioAttributes
import androidx.media3.common.MediaItem
import androidx.media3.exoplayer.ExoPlayer
import androidx.media3.exoplayer.analytics.AnalyticsListener

class RadioOnline(private val context: Context) {
    private var player: ExoPlayer? = null

    fun initializePlayer(streamUrl: String) {
        player = ExoPlayer.Builder(context).build().apply {
            setAudioAttributes(
                AudioAttributes.Builder()
                    .setContentType(androidx.media3.common.C.AUDIO_CONTENT_TYPE_MUSIC)
                    .setUsage(androidx.media3.common.C.USAGE_MEDIA)
                    .build(),
                true
            )
            setMediaItem(MediaItem.fromUri(streamUrl))
            prepare()
        }
    }

    /*fun checkStream(url: String, callback: (Boolean) -> Unit) {
        player = ExoPlayer.Builder(context).build().apply {
            val mediaItem = MediaItem.fromUri(Uri.parse(url))
            setMediaItem(mediaItem)

            addAnalyticsListener(object : AnalyticsListener {
                override fun onPlayerError(error: androidx.media3.common.PlaybackException) {
                    callback(false) // 🔴 URL no válida o caída
                    stopPlayer()
                }

                override fun onRenderedFirstFrame(
                    eventTime: AnalyticsListener.EventTime, surface: android.view.Surface?
                ) {
                    callback(true) // ✅ URL válida y reproduciendo
                    stopPlayer()
                }
            })
            prepare()
        }
    }*/

    fun play() {
        player?.playWhenReady = true
    }

    fun pause() {
        player?.playWhenReady = false
    }

    fun stop() {
        player?.release()
        player = null
    }

    fun isPlaying(): Boolean {
        return player?.isPlaying ?: false
    }

    fun setVolume(volume: Float) {
        player?.volume = volume.coerceIn(0.0f, 1.0f)
    }
    
    fun getVolume(): Float {
        return player?.volume ?: 0.0f  // Si el player es nulo, devuelve 0.0
    }
}


/*
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
 */