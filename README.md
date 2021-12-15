# InfoNASA
It's simple app that works with NASA official APIs in particular:
- APOD (Astronomy Picture of the Day)
- Asteroids - NeoWs (Near Earth Object Web Service)
- EPIC (Earth Polychromatic Imaging Camera)

App doesn't use Storyboard and done with layout by code.

## Structure
For navigation app uses NavogationController and TabBarController with the relevant tabs for each API data source.
TableViews by tapping cells presenting controllers with detailed info about selected object.

## Used technologies
- MVC
- URLSession and Alamofire
- CoreAnimation for images
- Image cache (Files + RAM)
- Layout by code
