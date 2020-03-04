package com.littlegnal.flutterembeddingaddon.flutter_embedding_addon_example

import android.content.Intent
import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import androidx.appcompat.widget.AppCompatButton
import androidx.core.content.ContextCompat.startActivity

class MainActivity : AppCompatActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        findViewById<AppCompatButton>(R.id.btnFlutterPage).setOnClickListener {
            startActivity(Intent(this, CustomFlutterFragmentActivity::class.java))
        }
    }
}
