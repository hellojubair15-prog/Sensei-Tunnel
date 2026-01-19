package com.sensei.tunnel.core

import androidx.annotation.Keep

@Keep
interface InvokeInterface {
    fun onResult(result: String?)
}