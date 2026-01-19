// IEventInterface.aidl
package com.sensei.tunnel.service;

import com.sensei.tunnel.service.IAckInterface;

interface IEventInterface {
    oneway void onEvent(in String id, in byte[] data,in boolean isSuccess, in IAckInterface ack);
}