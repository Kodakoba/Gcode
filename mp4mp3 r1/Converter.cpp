#pragma once
#include "Converter.h"

string filename = "";

int fconverter(int argc, char* argv[]) {
    vector<string> files;

    for (int g = 1; g < argc; g++) {
        string s = argv[g];
        int pos = s.find_last_of("\\", s.size());

        if (pos != -1) {
            filename = s.substr(pos + 1);

            cout << "argv[1] " << argv[1] << endl;
            cout << "\n filename: " << filename << "\n pos: " << pos << endl;
            files.push_back(filename);

        }
        files.push_back(s);
    }

    for (unsigned int k = 0; k < files.size(); k++)
    {
        cout << "files.at( " << k << " ): " << files.at(k).c_str() << endl;
        Converter a(files.at(k).c_str());
        a.getATCommandsFromCSV();
    }

    cout << "\n" << "Programm finished...\n\n" << endl;

    cin.ignore();
    throw filename;
}
