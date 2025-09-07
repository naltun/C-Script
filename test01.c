#!/usr/bin/env cscript

void greet(str name) {
    if (length(name) == 0)
        printf("Hello, World!\n");
    else {
        // A comment...
        printf("Hello, %s!\n", name);
    }
}

int main() {
    str name = "Noah";
    int age = 34;

    greet(name);
    printf("You are %d years old!\n", age);

    return 0;
}
