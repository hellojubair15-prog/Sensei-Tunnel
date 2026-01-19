package com.sensei.tunnel.service.models

import com.sensei.tunnel.common.GlobalState
import com.sensei.tunnel.common.formatBytes
import com.sensei.tunnel.core.Core
import com.google.gson.Gson

data class Traffic(
    val up: Long,
    val down: Long,
)

val Traffic.speedText: String
    get() = "${up.formatBytes}/s↑  ${down.formatBytes}/s↓"

fun Core.getSpeedTrafficText(onlyStatisticsProxy: Boolean): String {
    try {
        val res = getTraffic(onlyStatisticsProxy)
        val traffic = Gson().fromJson(res, Traffic::class.java)
        return traffic.speedText
    } catch (e: Exception) {
        GlobalState.log(e.message + "")
        return ""
    }
}