package org.wltea.analyzer.dic;
public class HotDict implements Runnable {
    @Override
    public void run() {
        while(true) {
            Dictionary.getSingleton().reLoadMainDict();
        }
    }

}
