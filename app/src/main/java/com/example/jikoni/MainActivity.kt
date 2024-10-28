package com.example.jikoni

import android.annotation.SuppressLint
import android.os.Bundle
import android.webkit.WebView
import android.widget.*
import androidx.activity.ComponentActivity
import androidx.appcompat.app.AppCompatDelegate

class MainActivity : ComponentActivity() {
    @SuppressLint("UseSwitchCompatOrMaterialCode", "SetTextI18n")
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        // Initialize controls
        findViewById<DatePicker>(R.id.datePicker)
        findViewById<TimePicker>(R.id.timePicker)
        val webView = findViewById<WebView>(R.id.webView)
        val autoCompleteTextView = findViewById<AutoCompleteTextView>(R.id.autoCompleteTextView)
        val spinner = findViewById<Spinner>(R.id.spinner)
        val button = findViewById<Button>(R.id.button)
        findViewById<EditText>(R.id.textField)
        val textView = findViewById<TextView>(R.id.textView)
        findViewById<RadioButton>(R.id.radioButton)
        findViewById<CheckBox>(R.id.checkBox)
        val toggleButton = findViewById<ToggleButton>(R.id.toggleButton)
        val darkModeSwitch = findViewById<Switch>(R.id.darkModeSwitch)

        // Set up WebView to show world map
        webView.loadUrl("https://www.google.com/maps")

        // Set up AutoCompleteTextView
        val suggestions = arrayOf("Pizza", "Burger", "Pasta", "Salad")
        val adapter = ArrayAdapter(this, android.R.layout.simple_list_item_1, suggestions)
        autoCompleteTextView.setAdapter(adapter)

        // Set up Spinner
        val spinnerAdapter = ArrayAdapter(this, android.R.layout.simple_spinner_item, suggestions)
        spinner.adapter = spinnerAdapter

        // Set up Button click listener
        button.setOnClickListener {
            textView.text = "Button clicked!"
        }

        // Set up ToggleButton listener
        toggleButton.setOnCheckedChangeListener { _, isChecked ->
            if (isChecked) {
                textView.text = "Toggle ON"
            } else {
                textView.text = "Toggle OFF"
            }
        }

        // Set up Dark Mode Switch listener
        darkModeSwitch.setOnCheckedChangeListener { _, isChecked ->
            if (isChecked) {
                AppCompatDelegate.setDefaultNightMode(AppCompatDelegate.MODE_NIGHT_YES)
            } else {
                AppCompatDelegate.setDefaultNightMode(AppCompatDelegate.MODE_NIGHT_NO)
            }
        }
    }
}