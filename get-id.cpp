// parse the "id_str" field of the json response
// this is faster compared to using jq

#include <fstream>

int main(int argc, char ** argv) {
    std::string s;
    std::ifstream fin(argv[1]);
    std::getline(fin, s);
    auto p = s.find("id_str");
    p += 9;
    s[p + 19] = 0;
    printf("%s\n", s.data() + p);
    return 0;
}
