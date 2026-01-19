package com.sensei.tunnel.models


data class AppState(
    val crashlytics: Boolean = true,
    val currentProfileName: String = "Sensei Tunnel",
    val stopText: String = "Stop",
    val onlyStatisticsProxy: Boolean = false,
)
