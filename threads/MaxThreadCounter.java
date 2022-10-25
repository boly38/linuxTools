/**
 * usage
 * with default limit
 * $ java MaxThreadCounter
 * with custom limit
 * $ MAX_THREAD_LIMIT=5000 java MaxThreadCounter
 */
public class MaxThreadCounter {
    private static int count = 0;
    private static boolean limitReached = false;

    private static final String MAX_THREAD_LIMIT = System.getenv("MAX_THREAD_LIMIT");
    private static final int TEST_MAX_THREAD_LIMIT = isNotEmpty(MAX_THREAD_LIMIT) ?
            Integer.parseInt(MAX_THREAD_LIMIT) : 50000;

    /**
     * manual test target platform thread limit
     */
    public static void main(String[] argv) {
        System.out.println("MAX_THREAD_LIMIT:" + MAX_THREAD_LIMIT + " - Counting ...");
        while (count++ < TEST_MAX_THREAD_LIMIT) {
            if (count % 1000 == 0) {
                System.out.println("count:" + count + " active:" + Thread.activeCount());
            }
            try {
                new Thread(() -> {
                    while (!limitReached) {
                        safeSleepMs(1000);
                    }
                }).start();
            } catch (Throwable e) {
                System.err.println("Number of thread :" + count);
                e.printStackTrace();
                safeSleepMs(5000);
                System.exit(0);
            }
        }
        System.out.println("we are done - Number of thread :" + count);
        limitReached = true;

    }

    private static void safeSleepMs(int delayMs) {
        try {
            Thread.sleep(delayMs);
        } catch (InterruptedException e1) {
            Thread.currentThread().interrupt();
            throw new RuntimeException("interrupted");
        }
    }

    public static boolean isEmpty(CharSequence cs) {
        return cs == null || cs.length() == 0;
    }

    public static boolean isNotEmpty(CharSequence cs) {
        return !isEmpty(cs);
    }
}
