#!/usr/bin/python3

import subprocess
import datetime

_SNAP_SUFFIX='snap'
_LVCREATE='/sbin/lvcreate'
_LVREMOVE='/sbin/lvremove'
_VG_NAME='vg_test'
_SNAP_SIZE='-L10M'
_MASTER_LV='/dev/vg_test/lv_test'
_VG_PATH='/dev/vg_test/'


def get_snaps() :
    snap_to_del=[]
    r=subprocess.Popen(['lvs','--noheadings','-o','lv_name'],stdout = subprocess.PIPE,shell=False)

    t_now=datetime.datetime.timestamp(datetime.datetime.now())

    for w in r.stdout :
        name_lv=str(w,'utf8').strip(' ').rstrip('\n')
        if name_lv.startswith(_SNAP_SUFFIX) :
            snap_timestamp=(float(name_lv.split('_')[1]))
            if t_now > snap_timestamp :
                snap_to_del.append(name_lv)
    return snap_to_del


def create_snap():
    t_now=datetime.datetime.timestamp(datetime.datetime.now())
    futur=datetime.datetime.timestamp(datetime.datetime.now() + datetime.timedelta(hours=0,minutes=5))
    lv_name='_'.join([_SNAP_SUFFIX,str(futur)])
    subprocess.check_call([_LVCREATE,'-s','-n',lv_name,_SNAP_SIZE,_MASTER_LV],shell=False)

def del_snaps(s_to_del):
    for s in s_to_del :
        try :
            subprocess.check_call([_LVREMOVE,'-f',''.join([_VG_PATH,s])],shell=False)
        except subprocess.CalledProcessError :
            print('send email')

create_snap()
a=get_snaps()
del_snaps(a)
