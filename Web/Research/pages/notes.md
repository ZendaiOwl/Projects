___Notes___

* TOC
{:toc}

---

# IETF

***Internet Engineering Task Force*** 

## Resources

1. **§** https://datatracker.ietf.org/
2. **§** https://authors.ietf.org/
3. **§** https://github.com/ietf-tools/rfcxml-templates-and-schemas 
4. **§** https://github.com/martinthomson/internet-draft-template 
5. **§** https://github.com/martinthomson/i-d-template/blob/main/doc/TEMPLATE.md 
6. **§** https://authors.ietf.org/en/content-guidelines-overview
7. **§** https://author-tools.ietf.org/

***RFC***

+  **§** RFC [1166][rfc1166] *Internet numbers*
+  **§** RFC [1918][rfc1918] *Address Allocation for Private Internets*
+  **§** RFC [2050][rfc2050] *Internet Registry IP Allocation Guidelines*
+  **§** RFC [2119][rfc2119] *Key words for use in RFCs to Indicate Requirement Levels*
+  **§** RFC [2606][rfc2606] *Reserved Top Level DNS Names*
+  **§** RFC [3849][rfc3849] *IPv6 Address Prefix Reserved for Documentation*
+  **§** RFC [5737][rfc5737] *IPv4 Address Blocks Reserved for Documentation*

RFC Documents can be found at: https://datatracker.ietf.org

+ **§** [RFC Tools][rfc-tools]
+ **§** [RFC Editor][rfc-editor]
+ **§** [Official Internet Protocol Standards][official-internet-protocol-standards]
+ **§** [RFC Tools Common - GitHub](https://github.com/ietf-tools/rfctools-common)
+ **§** [IETF Tools](https://github.com/ietf-tools)

<!-- RFC LINKS START -->
<!-- Base: https://datatracker.ietf.org/doc/ -->

[rfc-editor]: https://www.rfc-editor.org/
[official-internet-protocol-standards]: https://www.rfc-editor.org/standards
[rfc-tools]: https://www.rfctools.com/
[rfc1166]: https://datatracker.ietf.org/doc/rfc1166
[rfc1918]: https://datatracker.ietf.org/doc/rfc1918
[rfc2050]: https://datatracker.ietf.org/doc/rfc2050
[rfc2119]: https://datatracker.ietf.org/doc/rfc2119
[rfc2606]: https://datatracker.ietf.org/doc/rfc2606
[rfc3849]: https://datatracker.ietf.org/doc/rfc3849
[rfc5737]: https://datatracker.ietf.org/doc/rfc5737

<!-- RFC LINKS END -->


## RFC 1166 Internet Numbers 

[Source][rfc1166]

*The text below is a copy from the [RFC1166][rfc1166] document*

---

Status of this Memo

   This memo is a status report on the network numbers and autonomous
   system numbers used in the Internet community.  Distribution of this
   memo is unlimited.

Table of Contents

   Introduction............................................................... [1](https://datatracker.ietf.org/doc/html/rfc1166#page-1)
   
   Network Numbers.................................................... [4](https://datatracker.ietf.org/doc/html/rfc1166#page-4)
   
   Class A Networks..................................................... [7](https://datatracker.ietf.org/doc/html/rfc1166#page-7)
   
   Class B Networks..................................................... [8](https://datatracker.ietf.org/doc/html/rfc1166#page-8)
   
   Class C Networks................................................... [47](https://datatracker.ietf.org/doc/html/rfc1166#page-47)
   
   Other Reserved Internet Addresses................... [100](https://datatracker.ietf.org/doc/html/rfc1166#page-100)
   
   Network Totals...................................................... [101](https://datatracker.ietf.org/doc/html/rfc1166#page-101)
   
   Autonomous System Numbers........................... [102](https://datatracker.ietf.org/doc/html/rfc1166#page-102)
   
   Documents............................................................. [111](https://datatracker.ietf.org/doc/html/rfc1166#page-111)
   
   Contacts................................................................ [115](https://datatracker.ietf.org/doc/html/rfc1166#page-115)
   
   Security Considerations...................................... [182](https://datatracker.ietf.org/doc/html/rfc1166#page-182)
   
   Authors' Addresses............................................. [182](https://datatracker.ietf.org/doc/html/rfc1166#page-182)

---

*End of the copied text from [RFC1166][rfc1166] document* 

---

## IPv4 Address Blocks Reserved for Documentation

[RFC5737][rfc5737] *IPv4 Address Blocks Reserved for Documentation*

The blocks `192.0.2.0/24` (`TEST-NET-1`), `198.51.100.0/24` (`TEST-NET-2`), and `203.0.113.0/24` (`TEST-NET-3`) are provided for use in documentation.

1. `192.0.2.0/24` (`TEST-NET-1`)
2. `198.51.100.0/24` (`TEST-NET-2`)
3. `203.0.113.0/24` (`TEST-NET-3`)

## IPv6 Address Prefix Reserved for Documentation

[RFC3849][rfc3849] *IPv6 Address Prefix Reserved for Documentation*

The prefix allocated for documentation purposes is `2001:DB8::/32`

## TLD Names

[RFC2606][rfc2606] *Reserved Top Level DNS Names*

*Text below is copied from the [RFC2606][rfc2606] document*

---

[2](https://datatracker.ietf.org/doc/html/rfc2606#section-2). TLDs for Testing, & Documentation Examples

                   .test
                .example
                .invalid
              .localhost

      ".test" is recommended for use in testing of current or new DNS
      related code.

      ".example" is recommended for use in documentation or as examples.

      ".invalid" is intended for use in online construction of domain
      names that are sure to be invalid and which it is obvious at a
      glance are invalid.

      The ".localhost" TLD has traditionally been statically defined in
      host DNS implementations as having an A record pointing to the
      loop back IP address and is reserved for such use.  Any other use
      would conflict with widely deployed code which assumes this use.

[3](https://datatracker.ietf.org/doc/html/rfc2606#section-3). Reserved Example Second Level Domain Names

   The Internet Assigned Numbers Authority (IANA) also currently has the
   following second level domain names reserved which can be used as
   examples.

        example.com
        example.net
        example.org

---

*End of the copied text from the [RFC2606][rfc2606] document*

---

# Material Design Lite

https://getmdl.io/

https://code.getmdl.io/1.3.0/mdl.zip

*Material Design Lite lets you add a [Material Design](http://google.com/design/spec) look and feel to your websites. It doesn’t rely on any JavaScript frameworks and aims to optimize for cross-device use, gracefully degrade in older browsers, and offer an experience that is immediately accessible. [Get started now](https://getmdl.io/started/index.html).*

***License*** Copyright Google, 2015. Licensed under an Apache-2 license.

```html
<link rel="stylesheet" href="https://code.getmdl.io/1.3.0/material.blue-cyan.min.css" />
```

```html
<link rel="stylesheet" href="https://fonts.googleapis.com/icon?family=Material+Icons">
<link rel="stylesheet" href="https://code.getmdl.io/1.3.0/material.indigo-pink.min.css">
<script defer src="https://code.getmdl.io/1.3.0/material.min.js"></script>
```

<img src="{{ site.url }}/assets/images/material_design_lite_button.png" alt="Material Design Lite Button" />

```html
<!-- Accent-colored raised button with ripple -->
<button class="mdl-button mdl-js-button mdl-button--raised mdl-js-ripple-effect mdl-button--accent">
  Button
</button>
```

<img src="{{ site.url }}/assets/images/material_design_lite_fab_button.png" alt="Material Design Lite FAB Button" />

```html
<!-- Colored FAB button -->
<button class="mdl-button mdl-js-button mdl-button--fab mdl-button--colored">
  <i class="material-icons">add</i>
</button>
```

## Material Design Lite Templates

*The templates text & download links below is a copy from the [Material Design Lite's website](https://getmdl.io/)*

---

### Blog

A mobile focused responsive template that showcases image or text based blog entries, a subscription CTA, search & share links, and an expanded article page with comments, counters and bookmarking capabilities built-in.

[Download](https://code.getmdl.io/1.3.0/mdl-template-blog.zip) [Preview](https://getmdl.io/templates/blog/index.html)

### Android.com MDL skin

A Material Design Lite version of the current android.com site, using the same content with a horizontal navigation, feature carousel and long form scrolling sub pages.

[](https://code.getmdl.io/1.3.0/mdl-template-android-dot-com.zip)[Download](https://code.getmdl.io/1.3.0/mdl-template-android-dot-com.zip) [](https://getmdl.io/templates/android-dot-com/index.html)[Preview](https://getmdl.io/templates/android-dot-com/index.html)

### Dashboard

A modular responsive template built to display data visualizations and information with a clear vertical nav, user profile, search and dedicated space for updates and filters.

[](https://code.getmdl.io/1.3.0/mdl-template-dashboard.zip)[Download](https://code.getmdl.io/1.3.0/mdl-template-dashboard.zip) [](https://getmdl.io/templates/dashboard/index.html)[Preview](https://getmdl.io/templates/dashboard/index.html)

### Portfolio

A modern and clean looking template for a portfolio/blog build with Material Design Lite. Included are a top nav bar that comes with the waterfall header component, cards to display different types of content and a footer.

[](https://code.getmdl.io/1.3.0/mdl-template-portfolio.zip)[Download](https://code.getmdl.io/1.3.0/mdl-template-portfolio.zip) [](https://getmdl.io/templates/portfolio/index.html)[Preview](https://getmdl.io/templates/portfolio/index.html)

### Text-heavy webpage

Built for presenting content that is information dense, easily updatable, and optimized for legibility, this template has a sticky horizontal top nav on mobile, feature callouts, cards and a site map footer with a deep-linked table of contents.

[](https://code.getmdl.io/1.3.0/mdl-template-text-only.zip)[Download](https://code.getmdl.io/1.3.0/mdl-template-text-only.zip) [](https://getmdl.io/templates/text-only/index.html)[Preview](https://getmdl.io/templates/text-only/index.html)

### Stand-alone article

A clean layout optimized for presenting text-based content with a breadcrumb nav, search, clear headers and a footer that utilizes a card-like structure to showcase the content.

[](https://code.getmdl.io/1.3.0/mdl-template-article.zip)[Download](https://code.getmdl.io/1.3.0/mdl-template-article.zip) [](https://getmdl.io/templates/article/index.html)[Preview](https://getmdl.io/templates/article/index.html)

---

*End of the text copied from the [Material Design Lite's website](https://getmdl.io/)*

---

# Admin Dashboard Templates

***AdminLTE***

https://adminlte.io/

https://adminlte.io/docs

https://github.com/ColorlibHQ/AdminLTE

***Tabler***

https://tabler.io/

***Material Dashboard Lite***

https://github.com/CreativeIT/material-dashboard-lite

http://material-dashboard-lite.creativeit.io/

***Material Design Lite Dashboard Template***

https://code.getmdl.io/1.3.0/mdl-template-dashboard.zip


---

# Write the docs

https://www.writethedocs.org/

https://github.com/writethedocs

---

# Open Graph Protocol

https://ogp.me/

*Text copied from the open [graph protocol's website](https://ogp.me/)*

---
## [Introduction](https://ogp.me/#intro)

The [Open Graph protocol](https://ogp.me/) enables any web page to become a rich object in a social graph. For instance, this is used on Facebook to allow any web page to have the same functionality as any other object on Facebook.

While many different technologies and schemas exist and could be combined together, there isn't a single technology which provides enough information to richly represent any web page within the social graph. The Open Graph protocol builds on these existing technologies and gives developers one thing to implement. Developer simplicity is a key goal of the Open Graph protocol which has informed many of [the technical design decisions](https://www.scribd.com/doc/30715288/The-Open-Graph-Protocol-Design-Decisions).

## [Basic Metadata](https://ogp.me/#metadata)

To turn your web pages into graph objects, you need to add basic metadata to your page. We've based the initial version of the protocol on [RDFa](https://en.wikipedia.org/wiki/RDFa) which means that you'll place additional `<meta>` tags in the `<head>` of your web page. The four required properties for every page are:

- `og:title` - The title of your object as it should appear within the graph, e.g., "The Rock".
- `og:type` - The [type](https://ogp.me/#types) of your object, e.g., "video.movie". Depending on the type you specify, other properties may also be required.
- `og:image` - An image URL which should represent your object within the graph.
- `og:url` - The canonical URL of your object that will be used as its permanent ID in the graph, e.g., "https://www.imdb.com/title/tt0117500/".

As an example, the following is the Open Graph protocol markup for [The Rock on IMDB](https://www.imdb.com/title/tt0117500/):

```
<html prefix="og: https://ogp.me/ns#">
<head>
<title>The Rock (1996)</title>
<meta property="og:title" content="The Rock" />
<meta property="og:type" content="video.movie" />
<meta property="og:url" content="https://www.imdb.com/title/tt0117500/" />
<meta property="og:image" content="https://ia.media-imdb.com/images/rock.jpg" />
...
</head>
...
</html>
```

### [Optional Metadata](https://ogp.me/#optional)

The following properties are optional for any object and are generally recommended:

- `og:audio` - A URL to an audio file to accompany this object.
- `og:description` - A one to two sentence description of your object.
- `og:determiner` - The word that appears before this object's title in a sentence. An [enum](https://ogp.me/#enum) of (a, an, the, "", auto). If `auto` is chosen, the consumer of your data should chose between "a" or "an". Default is "" (blank).
- `og:locale` - The locale these tags are marked up in. Of the format `language_TERRITORY`. Default is `en_US`.
- `og:locale:alternate` - An [array](https://ogp.me/#array) of other locales this page is available in.
- `og:site_name` - If your object is part of a larger web site, the name which should be displayed for the overall site. e.g., "IMDb".
- `og:video` - A URL to a video file that complements this object.

For example (line-break solely for display purposes):

```
<meta property="og:audio" content="https://example.com/bond/theme.mp3" />
<meta property="og:description" 
  content="Sean Connery found fame and fortune as the
           suave, sophisticated British agent, James Bond." />
<meta property="og:determiner" content="the" />
<meta property="og:locale" content="en_GB" />
<meta property="og:locale:alternate" content="fr_FR" />
<meta property="og:locale:alternate" content="es_ES" />
<meta property="og:site_name" content="IMDb" />
<meta property="og:video" content="https://example.com/bond/trailer.swf" />
```

The RDF schema (in [Turtle](https://en.wikipedia.org/wiki/Turtle_(syntax))) can be found at [ogp.me/ns](https://ogp.me/ns/ogp.me.ttl).

---

## [Structured Properties](https://ogp.me/#structured)

Some properties can have extra metadata attached to them. These are specified in the same way as other metadata with `property` and `content`, but the `property` will have extra `:`.

The `og:image` property has some optional structured properties:

- `og:image:url` - Identical to `og:image`.
- `og:image:secure_url` - An alternate url to use if the webpage requires HTTPS.
- `og:image:type` - A [MIME type](https://en.wikipedia.org/wiki/Internet_media_type) for this image.
- `og:image:width` - The number of pixels wide.
- `og:image:height` - The number of pixels high.
- `og:image:alt` - A description of what is in the image (not a caption). If the page specifies an og:image it should specify `og:image:alt`.

A full image example:

```
<meta property="og:image" content="https://example.com/ogp.jpg" />
<meta property="og:image:secure_url" content="https://secure.example.com/ogp.jpg" />
<meta property="og:image:type" content="image/jpeg" />
<meta property="og:image:width" content="400" />
<meta property="og:image:height" content="300" />
<meta property="og:image:alt" content="A shiny red apple with a bite taken out" />
```

The `og:video` tag has the identical tags as `og:image`. Here is an example:

```
<meta property="og:video" content="https://example.com/movie.swf" />
<meta property="og:video:secure_url" content="https://secure.example.com/movie.swf" />
<meta property="og:video:type" content="application/x-shockwave-flash" />
<meta property="og:video:width" content="400" />
<meta property="og:video:height" content="300" />
```

The `og:audio` tag only has the first 3 properties available (since size doesn't make sense for sound):

```
<meta property="og:audio" content="https://example.com/sound.mp3" />
<meta property="og:audio:secure_url" content="https://secure.example.com/sound.mp3" />
<meta property="og:audio:type" content="audio/mpeg" />
```

---

## [Arrays](https://ogp.me/#array)

If a tag can have multiple values, just put multiple versions of the same `<meta>` tag on your page. The first tag (from top to bottom) is given preference during conflicts.

```
<meta property="og:image" content="https://example.com/rock.jpg" />
<meta property="og:image" content="https://example.com/rock2.jpg" />
```

Put structured properties after you declare their root tag. Whenever another root element is parsed, that structured property is considered to be done and another one is started.

For example:

```
<meta property="og:image" content="https://example.com/rock.jpg" />
<meta property="og:image:width" content="300" />
<meta property="og:image:height" content="300" />
<meta property="og:image" content="https://example.com/rock2.jpg" />
<meta property="og:image" content="https://example.com/rock3.jpg" />
<meta property="og:image:height" content="1000" />
```

means there are 3 images on this page, the first image is `300x300`, the middle one has unspecified dimensions, and the last one is `1000`px tall.

---

## [Object Types](https://ogp.me/#types)

In order for your object to be represented within the graph, you need to specify its type. This is done using the `og:type` property:

```
<meta property="og:type" content="website" />
```

When the community agrees on the schema for a type, it is added to the list of global types. All other objects in the type system are [CURIEs](https://en.wikipedia.org/wiki/CURIE) of the form

```
<head prefix="my_namespace: https://example.com/ns#">
<meta property="og:type" content="my_namespace:my_type" />
```

The global types are grouped into verticals. Each vertical has its own namespace. The `og:type` values for a namespace are always prefixed with the namespace and then a period. This is to reduce confusion with user-defined namespaced types which always have colons in them.

### [Music](https://ogp.me/#type_music)

- Namespace URI: [`https://ogp.me/ns/music#`](https://ogp.me/ns/music)

`og:type` values:

[`music.song`](https://ogp.me/#type_music.song)

- `music:duration` - [integer](https://ogp.me/#integer) >=1 - The song's length in seconds.
- `music:album` - [music.album](https://ogp.me/#type_music.album) [array](https://ogp.me/#array) - The album this song is from.
- `music:album:disc` - [integer](https://ogp.me/#integer) >=1 - Which disc of the album this song is on.
- `music:album:track` - [integer](https://ogp.me/#integer) >=1 - Which track this song is.
- `music:musician` - [profile](https://ogp.me/#type_profile) [array](https://ogp.me/#array) - The musician that made this song.

[`music.album`](https://ogp.me/#type_music.album)

- `music:song` - [music.song](https://ogp.me/#type_music.song) - The song on this album.
- `music:song:disc` - [integer](https://ogp.me/#integer) >=1 - The same as `music:album:disc` but in reverse.
- `music:song:track` - [integer](https://ogp.me/#integer) >=1 - The same as `music:album:track` but in reverse.
- `music:musician` - [profile](https://ogp.me/#type_profile) - The musician that made this song.
- `music:release_date` - [datetime](https://ogp.me/#datetime) - The date the album was released.

[`music.playlist`](https://ogp.me/#type_music.playlist)

- `music:song` - Identical to the ones on [music.album](https://ogp.me/#type_music.album)
- `music:song:disc`
- `music:song:track`
- `music:creator` - [profile](https://ogp.me/#type_profile) - The creator of this playlist.

[`music.radio_station`](https://ogp.me/#type_music.radio_station)

- `music:creator` - [profile](https://ogp.me/#type_profile) - The creator of this station.

### [Video](https://ogp.me/#type_video)

- Namespace URI: [`https://ogp.me/ns/video#`](https://ogp.me/ns/video)

`og:type` values:

[`video.movie`](https://ogp.me/#type_video.movie)

- `video:actor` - [profile](https://ogp.me/#type_profile) [array](https://ogp.me/#array) - Actors in the movie.
- `video:actor:role` - [string](https://ogp.me/#string) - The role they played.
- `video:director` - [profile](https://ogp.me/#type_profile) [array](https://ogp.me/#array) - Directors of the movie.
- `video:writer` - [profile](https://ogp.me/#type_profile) [array](https://ogp.me/#array) - Writers of the movie.
- `video:duration` - [integer](https://ogp.me/#integer) >=1 - The movie's length in seconds.
- `video:release_date` - [datetime](https://ogp.me/#datetime) - The date the movie was released.
- `video:tag` - [string](https://ogp.me/#string) [array](https://ogp.me/#array) - Tag words associated with this movie.

[`video.episode`](https://ogp.me/#type_video.episode)

- `video:actor` - Identical to [video.movie](https://ogp.me/#type_video.movie)
- `video:actor:role`
- `video:director`
- `video:writer`
- `video:duration`
- `video:release_date`
- `video:tag`
- `video:series` - [video.tv_show](https://ogp.me/#type_video.tv_show) - Which series this episode belongs to.

[`video.tv_show`](https://ogp.me/#type_video.tv_show)

A multi-episode TV show. The metadata is identical to [video.movie](https://ogp.me/#type_video.movie).

[`video.other`](https://ogp.me/#type_video.other)

A video that doesn't belong in any other category. The metadata is identical to [video.movie](https://ogp.me/#type_video.movie).

### [No Vertical](https://ogp.me/#no_vertical)

These are globally defined objects that just don't fit into a vertical but yet are broadly used and agreed upon.

`og:type` values:

[`article`](https://ogp.me/#type_article) - Namespace URI: [`https://ogp.me/ns/article#`](https://ogp.me/ns/article)

- `article:published_time` - [datetime](https://ogp.me/#datetime) - When the article was first published.
- `article:modified_time` - [datetime](https://ogp.me/#datetime) - When the article was last changed.
- `article:expiration_time` - [datetime](https://ogp.me/#datetime) - When the article is out of date after.
- `article:author` - [profile](https://ogp.me/#type_profile) [array](https://ogp.me/#array) - Writers of the article.
- `article:section` - [string](https://ogp.me/#string) - A high-level section name. E.g. Technology
- `article:tag` - [string](https://ogp.me/#string) [array](https://ogp.me/#array) - Tag words associated with this article.

[`book`](https://ogp.me/#type_book) - Namespace URI: [`https://ogp.me/ns/book#`](https://ogp.me/ns/book)

- `book:author` - [profile](https://ogp.me/#type_profile) [array](https://ogp.me/#array) - Who wrote this book.
- `book:isbn` - [string](https://ogp.me/#string) - The [ISBN](https://en.wikipedia.org/wiki/International_Standard_Book_Number)
- `book:release_date` - [datetime](https://ogp.me/#datetime) - The date the book was released.
- `book:tag` - [string](https://ogp.me/#string) [array](https://ogp.me/#array) - Tag words associated with this book.

[`profile`](https://ogp.me/#type_profile) - Namespace URI: [`https://ogp.me/ns/profile#`](https://ogp.me/ns/profile)

- `profile:first_name` - [string](https://ogp.me/#string) - A name normally given to an individual by a parent or self-chosen.
- `profile:last_name` - [string](https://ogp.me/#string) - A name inherited from a family or marriage and by which the individual is commonly known.
- `profile:username` - [string](https://ogp.me/#string) - A short unique string to identify them.
- `profile:gender` - [enum](https://ogp.me/#enum)(male, female) - Their gender.

[`website`](https://ogp.me/#type_website) - Namespace URI: [`https://ogp.me/ns/website#`](https://ogp.me/ns/website)

No additional properties other than the basic ones. Any non-marked up webpage should be treated as `og:type` website.

---

## [Types](https://ogp.me/#data_types)

The following types are used when defining attributes in Open Graph protocol.

|**Type**|**Description**|**Literals**|
|---|---|---|
|[Boolean](https://ogp.me/#bool)|A Boolean represents a true or false value|true, false, 1, 0|
|[DateTime](https://ogp.me/#datetime)|A DateTime represents a temporal value composed of a date (year, month, day) and an optional time component (hours, minutes)|[ISO 8601](https://en.wikipedia.org/wiki/ISO_8601)|
|[Enum](https://ogp.me/#enum)|A type consisting of bounded set of constant string values (enumeration members).|A string value that is a member of the enumeration|
|[Float](https://ogp.me/#float)|A 64-bit signed floating point number|All literals that conform to the following formats:  <br>  <br>1.234  <br>-1.234  <br>1.2e3  <br>-1.2e3  <br>7E-10|
|[Integer](https://ogp.me/#integer)|A 32-bit signed integer. In many languages integers over 32-bits become floats, so we limit Open Graph protocol for easy multi-language use.|All literals that conform to the following formats:  <br>  <br>1234  <br>-123|
|[String](https://ogp.me/#string)|A sequence of Unicode characters|All literals composed of Unicode characters with no escape characters|
|[URL](https://ogp.me/#url)|A sequence of Unicode characters that identify an Internet resource.|All valid URLs that utilize the https:// or https:// protocols|

## [Discussion and support](https://ogp.me/#discuss)

You can discuss the Open Graph Protocol in [the Facebook group](https://www.facebook.com/groups/opengraph/) or on [the developer mailing list](https://groups.google.com/group/open-graph-protocol). It is currently being consumed by Facebook ([see their documentation](https://developers.facebook.com/docs/opengraph/)), Google ([see their documentation](https://developers.google.com/+/web/+1button/#plus-snippet)), and [mixi](https://developer.mixi.co.jp/en/connect/mixi_plugin/mixi_check/spec_mixi_check/). It is being published by IMDb, Microsoft, NHL, Posterous, Rotten Tomatoes, TIME, Yelp, and many many others.

---

## [Implementations](https://ogp.me/#implementations)

The open source community has developed a number of parsers and publishing tools. Let the Facebook group know if you've built something awesome too!

- [Facebook Object Debugger](https://developers.facebook.com/tools/debug/) - Facebook's official parser and debugger
- [Google Rich Snippets Testing Tool](https://www.google.com/webmasters/tools/richsnippets) - Open Graph protocol support in specific verticals and Search Engines.
- [PHP Validator and Markup Generator](https://github.com/niallkennedy/open-graph-protocol-tools) - OGP 2011 input validator and markup generator in PHP5 objects
- [PHP Consumer](https://github.com/scottmac/opengraph) - a small library for accessing of Open Graph Protocol data in PHP
- [OpenGraphNode in PHP](https://buzzword.org.uk/2010/opengraph/#php) - a simple parser for PHP
- [PyOpenGraph](https://pypi.python.org/pypi/PyOpenGraph) - a library written in Python for parsing Open Graph protocol information from web sites
- [OpenGraph Ruby](https://github.com/intridea/opengraph) - Ruby Gem which parses web pages and extracts Open Graph protocol markup
- [OpenGraph for Java](https://github.com/callumj/opengraph-java) - small Java class used to represent the Open Graph protocol
- [RDF::RDFa::Parser](https://search.cpan.org/~tobyink/RDF-RDFa-Parser/lib/RDF/RDFa/Parser.pm) - Perl RDFa parser which understands the Open Graph protocol
- [WordPress plugin](https://wordpress.org/plugins/facebook/) - Facebook's official WordPress plugin, which adds Open Graph metadata to WordPress powered sites.
- [Alternate WordPress OGP plugin](https://wordpress.org/plugins/wp-facebook-open-graph-protocol/) - A simple lightweight WordPress plugin which adds Open Graph metadata to WordPress powered sites.

The Open Graph protocol was originally created at Facebook and is inspired by [Dublin Core](https://en.wikipedia.org/wiki/Dublin_Core), [link-rel canonical](https://googlewebmastercentral.blogspot.com/2009/02/specify-your-canonical.html), [Microformats](https://microformats.org/), and [RDFa](https://en.wikipedia.org/wiki/RDFa). The specification described on this page is available under the [Open Web Foundation Agreement, Version 0.9](https://openwebfoundation.org/legal/the-0-9-agreements---necessary-claims). This website is [Open Source](https://github.com/facebook/open-graph-protocol).

---

*End of text copied from [the open graph protocol's website](https://ogp.me/)*

---

# Values

+ **§** Truth *(Reality/God)*
+ **§** Merit
+ **§** Family
+ **§** Individual
+ **§** We the people 

---

# Random

+ Old river
+ Nameless thunder
+ Fae

---

```
grep -E '([0-9]{2})\1'
grep -E "(0\s?0|1\s?1|2\s?2|3\s?3|4\s?4|5\s?5|6\s?6|7\s?7|8\s?8|9\s?9)"
```

---

# Soldering temperatures

| Solder Type | Lead / Non-Lead | Temperature (°C) |
| :-- | :-- | :-- |
| 63/37 | lead | 183 |
| 60/40 | lead | 183-188 |
| 50/50 | lead | 183-212 |
| 45/55 | lead | 183-224 |
| 40/60 | lead | 183-234 |
| 96S | lead | 221 |
| 95A | lead | 236-243 |
| Alloy No. 1 | lead | 183-215 |
| Alloy No. 2 | lead | 183-190 |
| HMP 5S | lead | 296-301 |
| LMP 62S | lead | 179 |
| TLS/5 | lead | 296-301 |
| TIN | tin | 232 |
| 99C | non-lead | 227 |
| 97C | non-lead | 230-250 |
| SAC3 | non-lead | 217-219 |
| MC1 | non-lead | 232 |

Source: https://www.petervis.com/Education/Soldering_Guide_for_Electronics_Students/Soldering_Temperature.html

---
