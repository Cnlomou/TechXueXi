# import sys
# import signal
# from pdlearn import color
from threading import Thread
from threading import Lock
from concurrent.futures import ThreadPoolExecutor
import pdlearn.config as config

threadLock = Lock()


def initThreadPool():
    count = int(config.get_env_or_cfg("addition.MaxWorkers", 'MaxWorkers', def_value=4))
    print('初始线程数：', count)
    return ThreadPoolExecutor(count)


# stop_functions = []

# def regist_stop_function(func):
#     stop_functions.append(func)
#     print("注册了一个stop函数")
#     print(stop_functions)
#     func()

# def signal_handler(signal,frame):
#     print(color.red("检测到 Ctrl-C ，即将退出，正在清理工作线程..."))
#     for func in stop_functions:
#         print("即将执行：", func)
#         func()
#     print(color.green("工作线程清理完毕. Bye."))
#     sys.exit()

# signal.signal(signal.SIGINT,signal_handler)
def newTastandRun(fnc, *args):
    return executor.submit(fnc, *args)


class MyThread(Thread):
    def __init__(self, name, func, *args, lock=False):
        Thread.__init__(self)
        self.name = name
        self.func = func
        self.args = args
        self.lock = lock

    def run(self):
        print("开启: " + self.name)
        if self.lock:
            threadLock.acquire()
            self.func(*self.args)
            threadLock.release()
        else:
            self.func(*self.args)


executor = initThreadPool()
