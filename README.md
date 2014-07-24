Dofus anti-bot
==============
Cleaned code of Dofus anti-bot protection

**HumanCheck**
Main class, get all necessary string and generate anti-bot answer.

**StringDecode**
Call decoder and return decoded string.

**Decoder**
Decode file with XOR operation.  
Coming soon...

**Encoded file format**
- **red** : number of strings (int)
- **green** : string size (int)
- **blue** : encoded string (size * byte)

![encoded string format](https://raw.githubusercontent.com/LuaxY/Dofus-Anti-Bot/master/encoded%20string.png)