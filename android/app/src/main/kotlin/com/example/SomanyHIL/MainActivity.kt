package com.example.SomanyHIL

import android.Manifest
import android.app.Activity
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.provider.OpenableColumns
import android.util.Log
import androidx.annotation.NonNull
import com.canhub.cropper.CropImage
import com.canhub.cropper.CropImageView
import com.nabinbhandari.android.permissions.PermissionHandler
import com.nabinbhandari.android.permissions.Permissions
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File
import java.io.FileOutputStream
import java.io.InputStream

class MainActivity : FlutterActivity() {
    private val START_SERVICE = "in.eightfolds/captureImage"
    private var result: MethodChannel.Result? = null
    private val permissions =
            arrayOf(
                    Manifest.permission.CAMERA,
                    Manifest.permission.WRITE_EXTERNAL_STORAGE,
                    Manifest.permission.READ_EXTERNAL_STORAGE
            )

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, START_SERVICE).setMethodCallHandler { call, result ->
            when (call.method) {
                "captureImage" -> {
                    this.result = result
                    Permissions.check(
                            activity/*context*/,
                            permissions,
                            null/*rationale*/,
                            null/*options*/,
                            object : PermissionHandler() {
                                override fun onGranted() {
                                    CropImage.activity()
//                            .setFixAspectRatio(true)
                                            .setCropShape(CropImageView.CropShape.RECTANGLE)
                                            .setRequestedSize(720, 720, CropImageView.RequestSizeOptions.RESIZE_INSIDE)
                                            .setAspectRatio(1, 1)
                                            .start(activity)

                                    // ImagePicker
                                    /*ImagePicker.with(this)
                                            .cameraOnly()
                                            .crop()	    			//Crop image(Optional), Check Customization for more option
                                            .compress(512)			//Final image size will be less than 1 MB(Optional)
                                            .maxResultSize(1080, 1080)	//Final image resolution will be less than 1080 x 1080(Optional)
                                            .start()*/
                                }

                            })
                }

            }
        }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (requestCode == CropImage.CROP_IMAGE_ACTIVITY_REQUEST_CODE) {
            val result = CropImage.getActivityResult(data)
            if (resultCode == Activity.RESULT_OK) {
                val resultUri: Uri? = result?.uri
                resultUri?.let {
                    val path = getFilePathFromUri(this, it)
                    this.result?.success(path)
                }
            } else if (resultCode == CropImage.CROP_IMAGE_ACTIVITY_RESULT_ERROR_CODE) {
                val error = result!!.error
            }
        }

        // ImagePicker
        /*when (resultCode) {
            Activity.RESULT_OK -> {
                //Image Uri will not be null for RESULT_OK
                val resultUri: Uri? = data?.data

                resultUri?.let {
                    val path = getFilePathFromUri(this, it)
                    this.result?.success(path)
                }
            }
            ImagePicker.RESULT_ERROR -> {
                Toast.makeText(this, ImagePicker.getError(data), Toast.LENGTH_SHORT).show()
            }
            else -> {
                Toast.makeText(this, "Task Cancelled", Toast.LENGTH_SHORT).show()
            }
        }*/
    }

    fun getFilePathFromUri(context: Context, uri: Uri): String? {
        val returnCursor = context.contentResolver.query(uri, null, null, null, null) ?: return null
        /*
         * Get the column indexes of the data in the Cursor,
         *     * move to the first row in the Cursor, get the data,
         *     * and display it.
         * */
        val nameIndex = returnCursor.getColumnIndex(OpenableColumns.DISPLAY_NAME)
        val sizeIndex = returnCursor.getColumnIndex(OpenableColumns.SIZE)
        returnCursor.moveToFirst()
        val name = returnCursor.getString(nameIndex)
        val size = java.lang.Long.toString(returnCursor.getLong(sizeIndex))
        val file = File(context.filesDir, name)
        try {
            val inputStream: InputStream = context.contentResolver.openInputStream(uri)
                    ?: return null

            val outputStream = FileOutputStream(file)
            var read = 0
            val maxBufferSize = 1 * 1024 * 1024
            val bytesAvailable: Int = inputStream.available()

            //int bufferSize = 1024;
            val bufferSize = Math.min(bytesAvailable, maxBufferSize)
            val buffers = ByteArray(bufferSize)
            while (inputStream.read(buffers).also { read = it } != -1) {
                outputStream.write(buffers, 0, read)
            }
            Log.e("File Size", "Size " + file.length())
            inputStream.close()
            outputStream.close()
            returnCursor.close()
            Log.e("File Path", "Path " + file.path)
            Log.e("File Size", "Size " + file.length())
        } catch (e: java.lang.Exception) {
            Log.e("Exception", e.message ?: "")
        }
        return file.path
    }
}
