// app/src/main/java/com/example/jikoni/MainActivity.kt
package com.example.jikoni

import android.annotation.SuppressLint
import android.app.DatePickerDialog
import android.app.TimePickerDialog
import android.os.Bundle
import android.view.View
import android.webkit.WebView
import android.widget.*
import androidx.activity.ComponentActivity
import androidx.appcompat.app.AppCompatDelegate
import java.util.Calendar

class MainActivity : ComponentActivity() {
    @SuppressLint("SetJavaScriptEnabled", "MissingInflatedId")
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        // Initialize controls
        val webView = findViewById<WebView>(R.id.webView)
        val menuButton = findViewById<Button>(R.id.menuButton)
        val bookAppointmentButton = findViewById<Button>(R.id.bookAppointmentButton)
        val selectedDateTime = findViewById<TextView>(R.id.selectedDateTime)
        val locationSpinner = findViewById<Spinner>(R.id.locationSpinner)
        val confirmedDetails = findViewById<TextView>(R.id.confirmedDetails)
        val toggleButton = findViewById<ToggleButton>(R.id.toggleButton)
        val checklist = findViewById<LinearLayout>(R.id.checklist)
        val submitChecklist = findViewById<RadioButton>(R.id.submitChecklist)
        val autoCompleteTextView = findViewById<AutoCompleteTextView>(R.id.autoCompleteTextView)
        val clearButton = findViewById<Button>(R.id.clearButton)

        // Enable JavaScript if needed
        webView.settings.javaScriptEnabled = true

        // Set up Toggle Button click listener
        toggleButton.setOnCheckedChangeListener { _, isChecked ->
            if (isChecked) {
                toggleButton.textOn = "On"
                AppCompatDelegate.setDefaultNightMode(AppCompatDelegate.MODE_NIGHT_YES)
                checklist.visibility = View.VISIBLE
            } else {
                toggleButton.textOff = "Off"
                AppCompatDelegate.setDefaultNightMode(AppCompatDelegate.MODE_NIGHT_NO)
                checklist.visibility = View.GONE
                webView.loadDataWithBaseURL(null, getString(R.string.vintage_menu_html), "text/html", "UTF-8", null)
                bookAppointmentButton.visibility = View.VISIBLE
                submitChecklist.visibility = View.GONE
                autoCompleteTextView.visibility = View.VISIBLE
                clearButton.visibility = View.VISIBLE
            }
        }

        // Set up Menu Button click listener
        menuButton.setOnClickListener {
            // Load menu HTML from string resources
            val menuHtml = getString(R.string.vintage_menu_html)
            webView.loadDataWithBaseURL(null, menuHtml, "text/html", "UTF-8", null)
            bookAppointmentButton.visibility = View.VISIBLE
            if (toggleButton.isChecked) {
                checklist.visibility = View.VISIBLE
                submitChecklist.visibility = View.VISIBLE
            }
        }

        // Set up Book Appointment Button click listener
        bookAppointmentButton.setOnClickListener {
            showDateTimePicker { dateTime ->
                selectedDateTime.text = dateTime
                selectedDateTime.visibility = View.VISIBLE
                locationSpinner.visibility = View.VISIBLE
                setupLocationSpinner(locationSpinner)
            }
        }

        // Set up Submit Checklist click listener
        submitChecklist.setOnClickListener {
            val selectedLocations = mutableListOf<String>()
            if (findViewById<CheckBox>(R.id.location1).isChecked) selectedLocations.add("Indian")
            if (findViewById<CheckBox>(R.id.location2).isChecked) selectedLocations.add("Thai")
            if (findViewById<CheckBox>(R.id.location3).isChecked) selectedLocations.add("Chinese")
            if (findViewById<CheckBox>(R.id.location4).isChecked) selectedLocations.add("Islander")
            if (findViewById<CheckBox>(R.id.location5).isChecked) selectedLocations.add("Nordic")

            val confirmedDetails = findViewById<TextView>(R.id.confirmedDetails)
            confirmedDetails.text = "Selected Locations: ${selectedLocations.joinToString(", ")}"
            confirmedDetails.visibility = View.VISIBLE
        }

        // Set up AutoCompleteTextView
        val items = arrayOf("Indian", "Thai", "Chinese", "Islander", "Nordic", "Menu Item 1", "Menu Item 2")
        val adapter = ArrayAdapter(this, android.R.layout.simple_dropdown_item_1line, items)
        autoCompleteTextView.setAdapter(adapter)

        // Set up Clear Button click listener
        clearButton.setOnClickListener {
            autoCompleteTextView.text.clear()
        }
    }

    private fun showDateTimePicker(onDateTimeSelected: (String) -> Unit) {
        val calendar = Calendar.getInstance()
        val datePickerDialog = DatePickerDialog(this, { _, year, month, dayOfMonth ->
            val timePickerDialog = TimePickerDialog(this, { _, hourOfDay, minute ->
                val dateTime = "$dayOfMonth/${month + 1}/$year $hourOfDay:$minute"
                onDateTimeSelected(dateTime)
                showLocationPicker()
            }, calendar.get(Calendar.HOUR_OF_DAY), calendar.get(Calendar.MINUTE), true)
            timePickerDialog.show()
        }, calendar.get(Calendar.YEAR), calendar.get(Calendar.MONTH), calendar.get(Calendar.DAY_OF_MONTH))
        datePickerDialog.show()
    }

    private fun showLocationPicker() {
        // Implementation for showing location picker
    }

    @SuppressLint("SetTextI18n")
    private fun setupLocationSpinner(locationSpinner: Spinner) {
        val locations = arrayOf("Indian", "Thai", "Chinese", "Islander", "Nordic")
        val adapter = ArrayAdapter(this, android.R.layout.simple_spinner_item, locations)
        adapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item)
        locationSpinner.adapter = adapter

        locationSpinner.onItemSelectedListener = object : AdapterView.OnItemSelectedListener {
            override fun onItemSelected(parent: AdapterView<*>, view: View, position: Int, id: Long) {
                val selectedLocation = locations[position]
                val selectedDateTime = findViewById<TextView>(R.id.selectedDateTime).text.toString()
                val confirmedDetails = findViewById<TextView>(R.id.confirmedDetails)
                confirmedDetails.text = "Appointment confirmed for $selectedDateTime at $selectedLocation"
                confirmedDetails.visibility = View.VISIBLE
            }

            override fun onNothingSelected(parent: AdapterView<*>) {
                // Do nothing
            }
        }
    }
}