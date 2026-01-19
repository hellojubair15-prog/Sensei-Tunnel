package com.sensei.tunnel

import android.app.Application
import android.content.Context
import com.sensei.tunnel.common.GlobalState

class Application : Application() {

    override fun attachBaseContext(base: Context?) {
        super.attachBaseContext(base)
        GlobalState.init(this)
    }
}
