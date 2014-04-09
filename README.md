## urldiff

Computes and displays the visual differences between two URLs

urldiff takes two URLs, renders them as images and compairs them pixel by pixel outputs the visual difference in percentage between the two URLs and and generates a colour image of the differences.

#### Requires:
* Gems

```
gem install oily_png imgkit
```

* wkhtmltoimage

```bash
# Debian / Ubuntu
apt-get install wkhtmltopdf
```

OSX Binary available from: http://minimul.com/install-osx-wkhtmltoimage-binaries.html

#### Usage:
```bash
urldiff.rb -i sitelist.csv -o output.csv
```

#### Options:

    -i FILE read from CSV
    -o FILE output (append) results to CSV
    -f URL compare one site - First site
    -s URL compare one site - Second site

#### Example:
```bash
# cat sites.csv
http://www.google.com.au,http://www.google.co.nz

# urldiff.rb -i sites.csv -o output.csv

Rendering http://www.google.com.au
Rendering http://www.google.co.nz
Calculating Diff...
pixels (total):     1024000
pixels changed:     6269
pixels changed (%): 0.61220703125%

Generating DIFF-www.google.com.au-www.google.co.nz.png

Appending output to output.csv

# cat output.csv
http://www.google.com,http://www.google.co.nz,0.61220703125%

# ls *.png
www.google.com.au.png
www.google.co.nz.png
DIFF-www.google.com.au-www.google.co.nz.png
```

#### Screenshots:

##### First URL:

![First URL](/screenshots/url1.png "First URL")

##### Second URL:

![Second URL](/screenshots/url2.png "Second URL")

#####  Image Diff:

![Image Diff](/screenshots/urldiff.png "Image Diff")
