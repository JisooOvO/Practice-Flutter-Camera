package com.example.practice_flutter_camera

import android.content.ContentValues
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.os.Bundle
import android.provider.MediaStore
import android.widget.Toast
import android.media.ExifInterface
import androidx.activity.ComponentActivity
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel
import android.Manifest
import android.content.pm.PackageManager
import android.net.Uri
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import java.io.FileOutputStream


class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.example.gallery/saveImage"

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // 권한 요청
        if (ContextCompat.checkSelfPermission(this, Manifest.permission.WRITE_EXTERNAL_STORAGE)
            != PackageManager.PERMISSION_GRANTED) {
            ActivityCompat.requestPermissions(this, arrayOf(Manifest.permission.WRITE_EXTERNAL_STORAGE), 1)
        }

        // MethodChannel 설정
        MethodChannel(flutterEngine?.dartExecutor!!, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "saveImage") {
                val imagePath = call.argument<String>("imagePath")
                if (imagePath != null) {
                    saveImageToGallery(imagePath)
                    result.success("Image saved to gallery")
                } else {
                    result.error("UNAVAILABLE", "Image path not provided", null)
                }
            } else {
                result.notImplemented()
            }
        }
    }

    private fun saveImageToGallery(imagePath: String) {
        val contentValues = ContentValues().apply {
            put(MediaStore.Images.Media.DISPLAY_NAME, "image_${System.currentTimeMillis()}.jpg")
            put(MediaStore.Images.Media.MIME_TYPE, "image/jpeg")
            put(MediaStore.Images.Media.RELATIVE_PATH, "Pictures/YourAppFolder")
        }

        val contentResolver = contentResolver
        val uri: Uri? = contentResolver.insert(MediaStore.Images.Media.EXTERNAL_CONTENT_URI, contentValues)

        uri?.let {
            contentResolver.openOutputStream(it)?.use { outputStream ->
                // EXIF 회전 정보 반영
                val bitmap = BitmapFactory.decodeFile(imagePath)
                val exif = ExifInterface(imagePath)
                val orientation = exif.getAttributeInt(ExifInterface.TAG_ORIENTATION, ExifInterface.ORIENTATION_NORMAL)

                val rotatedBitmap = when (orientation) {
                    ExifInterface.ORIENTATION_ROTATE_90 -> rotateBitmap(bitmap, 90f)
                    ExifInterface.ORIENTATION_ROTATE_180 -> rotateBitmap(bitmap, 180f)
                    ExifInterface.ORIENTATION_ROTATE_270 -> rotateBitmap(bitmap, 270f)
                    else -> bitmap
                }

                rotatedBitmap.compress(Bitmap.CompressFormat.JPEG, 100, outputStream)
                Toast.makeText(this, "이미지가 갤러리에 저장되었습니다.", Toast.LENGTH_SHORT).show()
            }
        } ?: run {
            Toast.makeText(this, "이미지 저장 실패", Toast.LENGTH_SHORT).show()
        }
    }

    // 이미지를 회전시키는 함수
    private fun rotateBitmap(bitmap: Bitmap, degrees: Float): Bitmap {
        val matrix = android.graphics.Matrix()
        matrix.postRotate(degrees)
        return Bitmap.createBitmap(bitmap, 0, 0, bitmap.width, bitmap.height, matrix, true)
    }
}