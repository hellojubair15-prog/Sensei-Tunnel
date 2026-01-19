// ICallbackInterface.aidl
package com.sensei.tunnel.service;

import com.sensei.tunnel.service.IAckInterface;

interface ICallbackInterface {
    oneway void onResult(in byte[] data,in boolean isSuccess, in IAckInterface ack);
}