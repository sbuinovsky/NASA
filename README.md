# InfoNASA
It's simple app that works with NASA official APIs in particular:
- POD (Astronomy Picture of the Day)
- NEO (Near Earth Object Web Service)
- EPIC (Earth Polychromatic Imaging Camera)

App doesn't use Storyboard and done with layout by code.

## Structure
For navigation app uses NavogationController and TabBarController with the relevant tabs for each API data source.
TableViews by tapping cells presenting controllers with detailed info about selected object.

## Used technologies
- MVC
- URLSession and Alamofire
- GCD
- Realm
- Prefetching for tableViews
- CoreAnimation for images
- Image cache (Files + RAM)
- Layout by code
