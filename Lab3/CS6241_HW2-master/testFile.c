int main() {
    int i = 0;
    while (i < 100) {
        if (i%2 == 0) {
            i += 1;
        } else if (i%3 == 0) {
            i += 2;
        } else {
            i += 3;
        }
    }
    return 0;
}
