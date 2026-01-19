// IRemoteInterface.aidl
package com.sensei.tunnel.service;

import com.sensei.tunnel.service.ICallbackInterface;
import com.sensei.tunnel.service.IEventInterface;
import com.sensei.tunnel.service.IResultInterface;
import com.sensei.tunnel.service.models.VpnOptions;
import com.sensei.tunnel.service.models.NotificationParams;

interface IRemoteInterface {
    void invokeAction(in String data, in ICallbackInterface callback);
    void updateNotificationParams(in NotificationParams params);
    void startService(in VpnOptions options, in long runTime, in IResultInterface result);
    void stopService(in IResultInterface result);
    void setEventListener(in IEventInterface event);
    void setCrashlytics(in boolean enable);
    long getRunTime();
}