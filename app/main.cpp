#include <iostream>
#include "sum.hpp"
#include "sublib1/sublib1.hpp"
#include "sublib2/sublib2.hpp"
#include "sublib2/sublib21.hpp"
// #include "sublib2/sublib2.h"

int main()
{
    sublib1 hi;
    hi.print();

    sublib2 howdy;
    howdy.print();

    say_hello();
    
    std::cout << "Hola, como'stamos\n";
    std::cout << sum(10, 11) << '\n';
    return 0;
}
