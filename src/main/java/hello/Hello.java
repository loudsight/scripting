package hello;

import java.util.function.Consumer;

public class Hello implements Consumer<String[]> {

    @Override
    public void accept(String... objects) {
        System.out.println("Hello there");
    }
}
