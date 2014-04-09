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
urldiff.rb -f [first_url] -s [second_url] [options]
```

#### Options:

    -i FILE read from CSV
    -c FILE append results to CSV

#### Example:
```bash
# urldiff.rb -f http://www.google.com.au -s http://www.google.co.nz -c output.csv

Rendering http://www.google.com.au
Rendering http://www.google.co.nz
Calculating Diff...
pixels (total):     1024000
pixels changed:     6269
pixels changed (%): 0.61220703125%

Generating DIFF-www.google.com.au-www.google.co.nz.png

Appending output to output.csv

# cat output.csv
http://www.google.com vs http://www.google.co.nz,0.61220703125%
http://www.google.com vs http://www.google.co.nz,0.61220703125%
```

#### Screenshots:

##### First URL:

![First URL](/screenshots/url1.png "First URL")

##### Second URL:

![Second URL](/screenshots/url2.png "Second URL")

#####  Image Diff:

![Image Diff](/screenshots/urldiff.png "Image Diff")
