package com.sensei.tunnel.service

import com.sensei.tunnel.common.BroadcastAction
import com.sensei.tunnel.common.GlobalState
import com.sensei.tunnel.common.sendBroadcast

interface IBaseService {
    fun handleCreate() {
        GlobalState.log("Service create")
        BroadcastAction.SERVICE_CREATED.sendBroadcast()
    }

    fun handleDestroy() {
        GlobalState.log("Service destroy")
        BroadcastAction.SERVICE_DESTROYED.sendBroadcast()
    }

    fun start()

    fun stop()
}