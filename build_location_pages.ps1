# Generate rich, unique, high-quality Location SEO pages for Uttarakhand Car Rental Platform

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$locDir = Join-Path $scriptDir "locations"
if (-not (Test-Path $locDir)) { New-Item -ItemType Directory -Path $locDir -Force }

$locations = @(
    @{
        Slug = "dehradun"
        CityName = "Dehradun"
        Title = "Self Drive Car Rental in Dehradun | Airport & Station Delivery | ₹2,200/day"
        MetaDesc = "Rent a self-drive car in Dehradun starting at ₹2,200/day with 200 KM daily allowance. Airport delivery at Jolly Grant (DED), Railway Station & ISBT. Book on WhatsApp: +91 8923665501."
        H1 = "Self Drive Car Rental in Dehradun"
        Tagline = "Primary Operational Hub with Doorstep Delivery Across Dehradun"
        Intro = "Dehradun, the capital of Uttarakhand nestled in the Doon Valley, is the primary gateway to the Garhwal Himalayas. Whether arriving via flight at Jolly Grant Airport (DED), train at Dehradun Railway Station, or bus at ISBT, Car Rental Dehradun provides direct vehicle handover right at your arrival point. Enjoy the total freedom of self-drive to explore local attractions like Sahastradhara, Robber's Cave (Guchhupani), Mindrolling Monastery, Forest Research Institute (FRI), or head onward up to Mussoorie and Dhanaulti."
        PickupPoints = @("Jolly Grant Airport (DED) Terminal Handover", "Dehradun Railway Station Platform Exit", "ISBT Dehradun Inter-State Bus Terminus", "Rajpur Road / Clock Tower Commercial Centre", "Sahastradhara Road & IT Park", "Doorstep Delivery to any hotel/residence in Dehradun")
        RecommendedVehicles = "For local Dehradun city cruising and quick trips to Mussoorie, the **Maruti Swift Dzire (₹2,500/day)** and **Hyundai i20 (₹2,500/day)** offer exceptional fuel economy and effortless parking in hill bazaars. For groups and family holidays, the **Maruti Ertiga 7-Seater (₹3,500/day)** and **Mahindra Scorpio N (₹5,500/day)** deliver maximum seating comfort and mountain hill-climbing power."
        NearbyAttractions = @(
            @{ Name = "Sahastradhara Sulphur Springs"; Dist = "14 km from Clock Tower" },
            @{ Name = "Robber's Cave (Guchhupani)"; Dist = "8 km from City Centre" },
            @{ Name = "Forest Research Institute (FRI)"; Dist = "5 km on Chakrata Road" },
            @{ Name = "Tapkeshwar Mahadev Temple"; Dist = "6.5 km along Tons River" },
            @{ Name = "Mussoorie Queen of Hills"; Dist = "34 km via Rajpur Road" }
        )
        Faqs = @(
            @{ Q = "How does airport delivery at Jolly Grant Airport (DED) work?"; A = "Our representative meets you right outside the airport arrivals terminal with the car keys, rental agreement, and initial handover checklist. You can start driving immediately after quick original document verification." },
            @{ Q = "What is the kilometre allowance from Dehradun?"; A = "All our rentals come with 200 KM per calendar day allowance. A 3-day rental gives you 600 KM total allowance, which easily covers Dehradun-Mussoorie-Dhanaulti-Rishikesh loops." },
            @{ Q = "Can I pick up the car in Dehradun and drop it at Rishikesh or Mussoorie?"; A = "Yes, inter-city one-way drop off across Uttarakhand is supported upon prior coordination with our dispatch team." }
        )
    },
    @{
        Slug = "mussoorie"
        CityName = "Mussoorie"
        Title = "Self Drive Car Rental in Mussoorie | Hill Station Delivery | ₹2,200/day"
        MetaDesc = "Rent a self drive car for Mussoorie & Dhanaulti. Delivered at Mall Road, Library Chowk, Picture Palace or Dehradun base. 200 KM daily allowance. WhatsApp: +91 8923665501."
        H1 = "Self Drive Car Rental in Mussoorie"
        Tagline = "Explore the Queen of Hills, Kempty Falls & Dhanaulti at Your Own Pace"
        Intro = "Perched at an elevation of over 6,500 feet with panoramic views of the Doon Valley and snow-capped Himalayan peaks, Mussoorie is Uttarakhand's premier hill getaway. Renting a self-drive car allows you to bypass crowded shared taxis and explore scenic mountain switchbacks to Kempty Falls, George Everest Peak, Company Garden, Cloud's End, and the pristine deodar forests of Dhanaulti and Kanatal on your personal schedule."
        PickupPoints = @("Library Chowk / Gandhi Chowk Mussoorie", "Picture Palace / Kulri Bazaar", "Mall Road Entry Points", "Kempty Falls Road Resorts", "Dehradun Airport / Railway Station with onward hill drive")
        RecommendedVehicles = "Mountain hairpin curves and steep gradients make high-ground-clearance compact SUVs like the **Kia Sonet Automatic (₹3,500/day)** and **Hyundai Venue (₹2,500/day)** highly popular for Mussoorie trips. For adventure drives to Dhanaulti and Surkanda Devi, the **Mahindra Thar 4x4 (₹5,000/day)** delivers unmatched thrill and road grip."
        NearbyAttractions = @(
            @{ Name = "George Everest Peak & House"; Dist = "6 km from Library Chowk" },
            @{ Name = "Kempty Falls & Yamuna Bridge"; Dist = "15 km along Chakrata Road" },
            @{ Name = "Company Garden & Gun Hill"; Dist = "3 km from Mall Road" },
            @{ Name = "Cloud's End Forest Sanctuary"; Dist = "7 km west of Mussoorie" },
            @{ Name = "Dhanaulti Eco Park"; Dist = "28 km via Tehri Bypass" }
        )
        Faqs = @(
            @{ Q = "Is hill driving permitted in your rental cars for Mussoorie?"; A = "Yes! All our vehicles are mechanically tested, equipped with hill assist/ABS, and commercially permitted for all Uttarakhand mountain roads including Mussoorie and Dhanaulti." },
            @{ Q = "What are the parking rules in Mussoorie?"; A = "Mussoorie has designated multi-level car parkings at Library Chowk, Picture Palace, and Kingcraig. Avoid parking along narrow Mall Road stretches during peak hours." }
        )
    },
    @{
        Slug = "rishikesh"
        CityName = "Rishikesh"
        Title = "Self Drive Car Rental in Rishikesh | Tapovan & Rafting Hub Delivery"
        MetaDesc = "Book self-drive car rentals in Rishikesh starting at ₹2,200/day. Delivery in Tapovan, Laxman Jhula, AIIMS & Railway Station. 200 KM daily allowance. Call: +91 8923665501."
        H1 = "Self Drive Car Rental in Rishikesh"
        Tagline = "The World Yoga Capital, White-Water Rafting & Himalayan Gateway"
        Intro = "Rishikesh, situated where the holy Ganga descends from the Shivalik Himalayas into the plains, is a world-renowned destination for yoga, river rafting, bungee jumping, and spiritual retreats. Having a self-drive rental car gives you seamless access to rafting put-in points at Shivpuri and Marine Drive, sunrise trips to Kunjapuri Devi Temple, waterfall hikes at Neer Garh, and onward road journeys into the Garhwal highlands."
        PickupPoints = @("Tapovan & Laxman Jhula Auto Stand", "Rishikesh Railway Station (Yog Nagari Rishikesh)", "AIIMS Rishikesh & Haridwar Road", "Shivpuri Rafting Camp Delivery", "Dehradun Jolly Grant Airport (only 20 km away)")
        RecommendedVehicles = "The **Maruti Swift Dzire (₹2,500/day)** and **Toyota Glanza Automatic (₹2,200/day)** provide effortless transit between Rishikesh cafes, yoga ashrams, and Haridwar ghats. For rafting gear and camping groups, the **Mahindra Scorpio N (₹5,500/day)** and **Maruti Ertiga (₹3,500/day)** are the premier choices."
        NearbyAttractions = @(
            @{ Name = "Triveni Ghat Ganga Aarti"; Dist = "City Centre Rishikesh" },
            @{ Name = "Neer Garh Waterfalls"; Dist = "5 km from Tapovan" },
            @{ Name = "Shivpuri White-Water Rafting"; Dist = "16 km upstream on Badrinath Hwy" },
            @{ Name = "Kunjapuri Sunrise Temple"; Dist = "25 km mountain drive" },
            @{ Name = "Beatles Ashram (Chaurasi Kutia)"; Dist = "Swarg Ashram area" }
        )
        Faqs = @(
            @{ Q = "How far is Jolly Grant Airport from Rishikesh?"; A = "Jolly Grant Airport (DED) is just 20 km (approx. 30 minutes drive) from Tapovan, Rishikesh. We can hand over the car directly at the airport terminal." },
            @{ Q = "Can I take the car for Char Dham Yatra starting from Rishikesh?"; A = "Yes, Rishikesh is the traditional starting point for the Char Dham Yatra. Our Scorpio N, Thar, and Ertiga are fully equipped for the entire Yatra circuit." }
        )
    },
    @{
        Slug = "haridwar"
        CityName = "Haridwar"
        Title = "Self Drive Car Rental in Haridwar | Har Ki Pauri & Station Pickup"
        MetaDesc = "Rent a self-drive car in Haridwar at ₹2,200/day. Doorstep handover at Haridwar Railway Station, Har Ki Pauri, and SIDCUL. 200 KM daily allowance included. WhatsApp: +91 8923665501."
        H1 = "Self Drive Car Rental in Haridwar"
        Tagline = "Sacred Ganga Ghats, Temple Tours & Industrial Corridor Mobility"
        Intro = "Haridwar is one of India's seven holiest pilgrimage centers, welcoming millions of devotees each year to Har Ki Pauri, Mansa Devi, Chandi Devi, and Daksh Prajapati Temple. Renting a self-drive car offers complete convenience for family pilgrimage tours, temple visits, transit between Haridwar and Rishikesh via the express highway, and corporate travel to the SIDCUL industrial complex."
        PickupPoints = @("Haridwar Junction Railway Station Exit", "Har Ki Pauri / Motichur Area", "SIDCUL Industrial Area & Hotels", "Shanti Kunj / Rishikesh Highway", "Roorkee-Haridwar Highway Junction")
        RecommendedVehicles = "For family pilgrimage groups, the **Maruti Ertiga 7-Seater (₹3,500/day)** provides comfortable air-conditioned seating for 7 passengers. For couples and solo travelers, the **Maruti Baleno (₹2,200/day)** offers unbeatable economy and smooth automatic/manual cruising."
        NearbyAttractions = @(
            @{ Name = "Har Ki Pauri Evening Ganga Aarti"; Dist = "Haridwar Ghat" },
            @{ Name = "Mansa Devi & Chandi Devi Ropeway"; Dist = "Shivalik Hills" },
            @{ Name = "Daksha Mahadev Temple, Kankhal"; Dist = "4 km south of city" },
            @{ Name = "Rajaji National Park Chilla Gate"; Dist = "12 km across Ganga Barrage" },
            @{ Name = "Rishikesh Divine City"; Dist = "24 km via 4-lane highway" }
        )
        Faqs = @(
            @{ Q = "How does delivery at Haridwar Railway Station work?"; A = "Our representative meets you at the designated station parking lot with the vehicle, complete documents, and sanitized cabin ready for your trip." },
            @{ Q = "What is the distance between Haridwar and Dehradun?"; A = "Haridwar to Dehradun is approximately 52 km (about 1 hour via the smooth 4-lane national highway)." }
        )
    },
    @{
        Slug = "nainital"
        CityName = "Nainital"
        Title = "Self Drive Car Rental in Nainital | Lake District Touring | ₹2,200/day"
        MetaDesc = "Rent a self drive car in Nainital & Kumaon lake district. Pick up in Nainital, Kathgodam or Dehradun base. 200 KM daily allowance. Call / WhatsApp: +91 8923665501."
        H1 = "Self Drive Car Rental in Nainital"
        Tagline = "Emerald Lakes, Pine Hills & Spectacular Himalayan Viewpoints"
        Intro = "Set around the shimmering eye-shaped Naini Lake at an altitude of 6,837 feet, Nainital is the jewel of Kumaon. Having your own self-drive vehicle unlocks the entire Lake Tour circuit—including Bhimtal, Naukuchiatal, Sattal, Khurpatal, and the scenic pine-clad viewpoints of Snow View, Tiffin Top, and Pangot Bird Sanctuary—without having to bargain for local tourist taxis."
        PickupPoints = @("Tallital & Mallital Bus Stands", "Kathgodam Railway Station (Gateway to Nainital)", "Bhimtal & Bhowali Junctions", "Nainital-Haldwani Highway", "Dehradun Hub with onward Kumaon Road Trip")
        RecommendedVehicles = "Steep mountain roads around Nainital and Pangot benefit greatly from compact SUVs like the **Hyundai Venue (₹2,500/day)** and **Kia Sonet (₹3,500/day)**. For group lake tours, the **Maruti Ertiga (₹3,500/day)** comfortably carries family members and luggage."
        NearbyAttractions = @(
            @{ Name = "Naini Lake & Naina Devi Temple"; Dist = "Mallital & Tallital" },
            @{ Name = "Bhimtal Lake & Island Aquarium"; Dist = "22 km from Nainital" },
            @{ Name = "Sattal (Seven Lakes) Nature Reserve"; Dist = "23 km via Bhowali" },
            @{ Name = "Naukuchiatal Nine-Cornered Lake"; Dist = "26 km via Bhimtal" },
            @{ Name = "Kainchi Dham (Neem Karoli Baba)"; Dist = "18 km on Almora Road" }
        )
        Faqs = @(
            @{ Q = "Can we visit Kainchi Dham Ashram from Nainital in your rental car?"; A = "Yes! Kainchi Dham is an easy 40-minute drive (18 km) from Nainital. Our cars provide hassle-free direct access with 200 KM daily allowance." },
            @{ Q = "What are the entry and toll rules for cars in Nainital?"; A = "Nainital has a nominal municipality entry toll and designated parking areas at Tallital, Sukhatal, and High Court road." }
        )
    },
    @{
        Slug = "haldwani"
        CityName = "Haldwani"
        Title = "Self Drive Car Rental in Haldwani & Kathgodam | Kumaon Gateway"
        MetaDesc = "Self drive car rentals in Haldwani and Kathgodam Railway Station. Start your road trip to Nainital, Almora, Ranikhet & Corbett with 200 KM daily limit. Call: +91 8923665501."
        H1 = "Self Drive Car Rental in Haldwani"
        Tagline = "Commercial Hub of Kumaon & Kathgodam Railhead Connectivity"
        Intro = "Haldwani, together with the adjacent railhead at Kathgodam, forms the principal economic gateway to the entire Kumaon division of Uttarakhand. Travellers arriving on Shatabdi, Ranikhet Express, or Bagh Express at Kathgodam can take direct delivery of a self-drive rental car to start their mountain journeys towards Nainital, Almora, Mukteshwar, Binsar, Kausani, or Munsiyari with complete independence."
        PickupPoints = @("Kathgodam Railway Station Entrance", "Haldwani Bus Terminal / Bareilly Road", "Tikonia Chowk & Nainital Road", "Kaladhungi Road (Corbett Route)", "Pantnagar Airport Pickup (28 km)")
        RecommendedVehicles = "For long Kumaon highland drives spanning Haldwani, Almora, and Kausani, the **Mahindra Scorpio N (₹5,500/day)** and **Kia Sonet (₹3,500/day)** deliver effortless power on winding mountain climbs. For economy touring, the **Toyota Glanza (₹2,200/day)** and **Maruti Baleno (₹2,200/day)** offer superior mileage."
        NearbyAttractions = @(
            @{ Name = "Kathgodam Gaula Barrage"; Dist = "6 km from Haldwani" },
            @{ Name = "Kaladhungi Corbett Museum"; Dist = "26 km on Ramnagar Road" },
            @{ Name = "Jeolikote Fruit Orchards"; Dist = "18 km on Nainital Ghat" },
            @{ Name = "Bhimtal Lake"; Dist = "28 km via Ranibagh" }
        )
        Faqs = @(
            @{ Q = "Can the car be delivered directly at Kathgodam Railway Station?"; A = "Yes, we coordinate station delivery aligned with your train arrival time for a seamless transition into your self-drive vehicle." }
        )
    },
    @{
        Slug = "jim-corbett"
        CityName = "Jim Corbett"
        Title = "Self Drive Car Rental in Jim Corbett (Ramnagar) | Safari Resort Transit"
        MetaDesc = "Rent a self drive car in Jim Corbett National Park & Ramnagar starting at ₹2,200/day. Ideal for jungle resort stays and Corbett safaris. 200 KM daily allowance. Call +91 8923665501."
        H1 = "Self Drive Car Rental in Jim Corbett"
        Tagline = "India's Premier Tiger Reserve, Jungle Resorts & Kosi River Valley"
        Intro = "Jim Corbett National Park in Ramnagar is legendary as India's oldest national park and premier tiger reserve. While open-top registered 4x4 gypsies operate internal core-zone safari tracks, having a self-drive rental car is essential for driving between secluded river resorts along the Kosi river in Dhikuli, visiting Garjiya Devi Temple, exploring Sitabani forest trails, Corbett Falls, and taking day trips up to Nainital and Ranikhet."
        PickupPoints = @("Ramnagar Railway Station & Bus Stand", "Dhikuli Resort Zone along Kosi River", "Mohaan & Marchula Valley", "Corbett Falls & Kaladhungi Road", "Dehradun Hub with scenic expressway drive to Corbett")
        RecommendedVehicles = "The rugged **Mahindra Thar 4x4 (₹5,000/day)** matches the authentic jungle lifestyle and forest trails around Ramnagar. For families staying at luxury wilderness resorts, the **Mahindra Scorpio N (₹5,500/day)** and **Maruti Ertiga (₹3,500/day)** provide spacious comfort for all luggage."
        NearbyAttractions = @(
            @{ Name = "Garjiya Devi Temple & Kosi River"; Dist = "14 km from Ramnagar" },
            @{ Name = "Corbett Waterfall & Museum"; Dist = "25 km on Kaladhungi Road" },
            @{ Name = "Sitabani Wildlife Sanctuary"; Dist = "20 km via Pawalgarh" },
            @{ Name = "Marchula Suspension Bridge & River View"; Dist = "32 km along Ramganga" }
        )
        Faqs = @(
            @{ Q = "Can I drive a rental car inside the national park for safaris?"; A = "Park safari zones (Dhikala, Bijrani, Jhirna) require registered park gypsies and official forest guides. However, our rental cars are ideal for all resort commuting, transit, Sitabani buffer zones, and surrounding hill tours." }
        )
    },
    @{
        Slug = "auli"
        CityName = "Auli"
        Title = "Self Drive Car Rental for Auli & Joshimath | High Altitude 4x4 SUVs"
        MetaDesc = "Hire a reliable self-drive SUV or 4x4 for Auli and Joshimath. Heavy duty diesel Scorpio N & Thar with 200 KM daily limit. Book on WhatsApp: +91 8923665501."
        H1 = "Self Drive Car Rental for Auli & Joshimath"
        Tagline = "Ski Slopes, Apple Orchards & Spectacular Views of Nanda Devi"
        Intro = "Located at an altitude of over 9,000 feet in Chamoli district, Auli is India's premier skiing destination and offers breathtaking 360-degree views of Nanda Devi, Trishul, and Kamet peaks. Driving to Auli involves traversing the picturesque Badrinath National Highway (NH-07) through Devprayag, Rudraprayag, Karnaprayag, and Joshimath. A robust, well-maintained self-drive SUV ensures safety, comfort, and reliability throughout this majestic Himalayan expedition."
        PickupPoints = @("Dehradun Base (Recommended start for NH-07 route)", "Rishikesh Yog Nagari Station", "Joshimath Town Centre & Ropeway Base", "Haridwar Railway Station")
        RecommendedVehicles = "High-torque diesel power and high ground clearance are crucial for the 280 km mountain drive to Joshimath/Auli. We strongly recommend the **Mahindra Scorpio N Turbo Diesel (₹5,500/day)** and the **Mahindra Thar 4x4 (₹5,000/day)** for steep gradients and cold weather reliability."
        NearbyAttractions = @(
            @{ Name = "Auli Artificial Lake & Ski Slopes"; Dist = "Upper Auli" },
            @{ Name = "Joshimath Shankaracharya Math"; Dist = "14 km below Auli" },
            @{ Name = "Gorson Bugyal Himalayan Meadow Trek"; Dist = "3 km trek from Auli" },
            @{ Name = "Tapovan Hot Sulphur Springs"; Dist = "15 km from Joshimath" }
        )
        Faqs = @(
            @{ Q = "How long does it take to drive from Dehradun/Rishikesh to Auli?"; A = "The drive from Rishikesh/Dehradun to Joshimath is approximately 250-280 km and typically takes 8 to 10 hours along the scenic all-weather Char Dham highway. An overnight stopover in Srinagar or Rudraprayag is recommended for a relaxed trip." }
        )
    },
    @{
        Slug = "dhanaulti"
        CityName = "Dhanaulti"
        Title = "Self Drive Car Rental for Dhanaulti & Kanatal | Peaceful Deodar Hills"
        MetaDesc = "Rent a self drive car for Dhanaulti & Kanatal road trips. Explore Eco Parks, Surkanda Devi, and apple orchards with 200 KM/day allowance. WhatsApp: +91 8923665501."
        H1 = "Self Drive Car Rental for Dhanaulti"
        Tagline = "Dense Deodar Groves, Alpine Camping & Quiet Mountain Escapes"
        Intro = "Located just 28 km beyond Mussoorie along the scenic Mussoorie-Chamba ridge road at an elevation of 7,500 feet, Dhanaulti is celebrated for its peaceful deodar forests, cool alpine breeze, and panoramic Himalayan vistas. A self-drive car rental gives you the freedom to explore Eco Park, trek up to Surkanda Devi Temple, stay at adventure camps in Kanatal, and loop down via Chamba and Tehri Lake back to Rishikesh."
        PickupPoints = @("Dehradun Base (Short 2-hour drive)", "Mussoorie Mall Road", "Dhanaulti Main Bazaar", "Kanatal Camping Zone")
        RecommendedVehicles = "The **Kia Sonet Automatic (₹3,500/day)** and **Hyundai Venue (₹2,500/day)** handle the high-altitude curves with ease. For off-grid camping and lifestyle photography, the **Mahindra Thar (₹5,000/day)** is the top customer choice."
        NearbyAttractions = @(
            @{ Name = "Dhanaulti Eco Park (Amber & Dhara)"; Dist = "Town Centre" },
            @{ Name = "Surkanda Devi Temple (9,995 ft)"; Dist = "8 km on Chamba Road" },
            @{ Name = "Kanatal Adventure Camps"; Dist = "14 km towards Chamba" },
            @{ Name = "Apple Orchard & Potato Farm"; Dist = "1 km from main road" }
        )
        Faqs = @(
            @{ Q = "Can we do a complete Dehradun-Mussoorie-Dhanaulti-Rishikesh circuit?"; A = "Yes! This scenic 150 km circular circuit is one of Uttarakhand's finest weekend drives. Our standard 200 KM daily allowance easily covers this entire route." }
        )
    },
    @{
        Slug = "chakrata"
        CityName = "Chakrata"
        Title = "Self Drive Car Rental for Chakrata & Tiger Falls | Unexplored Garhwal"
        MetaDesc = "Explore Chakrata and Tiger Falls in a self drive rental car. Direct delivery from Dehradun. 200 KM daily allowance, robust SUVs. Call: +91 8923665501."
        H1 = "Self Drive Car Rental for Chakrata"
        Tagline = "Virgin Pine Forests, Roaring Waterfalls & Secluded Cantonment Serenity"
        Intro = "Chakrata, situated 88 km from Dehradun at an altitude of 7,000 feet, is an untouched cantonment hill station renowned for its tranquility, towering deodar trees, and the magnificent 312-foot Tiger Falls. Renting a self-drive car is the most comfortable and reliable way to access Chakrata's scenic viewpoints like Deoban, Budher Caves (Miola Top), and Chilmiri Neck without relying on scarce mountain buses."
        PickupPoints = @("Dehradun Base (Primary Handover Hub)", "Herbertpur & Vikasnagar Highway", "Chakrata Main Bazaar")
        RecommendedVehicles = "Mountain gradients and winding forest switchbacks around Chakrata are best suited for compact SUVs like the **Hyundai Venue (₹2,500/day)**, **Kia Sonet (₹3,500/day)**, or heavy-duty **Mahindra Scorpio N (₹5,500/day)**."
        NearbyAttractions = @(
            @{ Name = "Tiger Falls (Direct drop waterfall)"; Dist = "17 km from Chakrata" },
            @{ Name = "Deoban (9,300 ft Himalayan viewpoint)"; Dist = "13 km forest drive" },
            @{ Name = "Chilmiri Neck Sunset Point"; Dist = "4 km from town" },
            @{ Name = "Budher Caves & Moila Top Meadow"; Dist = "30 km on Tiuni Road" }
        )
        Faqs = @(
            @{ Q = "Are foreign tourists allowed in Chakrata?"; A = "Chakrata is a cantonment zone. Indian citizens require standard ID proofs. Foreign nationals require special permits from the Ministry of Defence to enter the cantonment area." }
        )
    },
    @{
        Slug = "lansdowne"
        CityName = "Lansdowne"
        Title = "Self Drive Car Rental for Lansdowne | Peaceful Hill Station Touring"
        MetaDesc = "Hire self drive cars for Lansdowne cantonment hill station. Pick up at Kotdwar, Haridwar or Dehradun base. 200 KM/day allowance. WhatsApp: +91 8923665501."
        H1 = "Self Drive Car Rental for Lansdowne"
        Tagline = "Garhwal Rifles Heritage, Bhulla Lake & Quiet Oak-Pine Walks"
        Intro = "Lansdowne, established as a military garrison in 1887 and home to the renowned Garhwal Rifles regiment, is one of Uttarakhand's cleanest and most peaceful hill stations. Located approximately 155 km from Dehradun via Kotdwar, a self-drive rental car allows you to explore Tip-in-Top viewpoint, Bhulla Lake, St. John's Church, Tarkeshwar Mahadev temple in the tall deodar woods, and enjoy unhurried mountain serenity."
        PickupPoints = @("Kotdwar Railway Station Exit", "Dehradun Hub", "Haridwar Junction", "Lansdowne Gandhi Chowk")
        RecommendedVehicles = "The **Maruti Swift Dzire (₹2,500/day)** and **Toyota Glanza (₹2,200/day)** deliver smooth performance on the Kotdwar-Lansdowne highway. For family holidays, the **Maruti Ertiga (₹3,500/day)** provides ample space for luggage and passengers."
        NearbyAttractions = @(
            @{ Name = "Tip-in-Top (Tiffin Top) Viewpoint"; Dist = "1.5 km from Lansdowne" },
            @{ Name = "Bhulla Lake & Boating Complex"; Dist = "1 km from town centre" },
            @{ Name = "Tarkeshwar Mahadev Temple & Deodar Forest"; Dist = "38 km scenic drive" },
            @{ Name = "Darwan Singh Garhwal Museum"; Dist = "Parade Ground area" }
        )
        Faqs = @(
            @{ Q = "What is the driving route from Dehradun to Lansdowne?"; A = "Take Dehradun -> Haridwar -> Najibabad -> Kotdwar -> Dugadda -> Lansdowne (approx. 155 km, 4.5 hours drive)." }
        )
    },
    @{
        Slug = "tehri"
        CityName = "Tehri Garhwal"
        Title = "Self Drive Car Rental in Tehri Garhwal | Tehri Lake & Water Sports"
        MetaDesc = "Rent a self drive car for Tehri Lake, New Tehri & Chamba. Clean cars with 200 KM daily allowance. Instant WhatsApp booking: +91 8923665501."
        H1 = "Self Drive Car Rental in Tehri Garhwal"
        Tagline = "Asia's Largest Dam Lake, Jet Skiing, Houseboats & Mountain Vistas"
        Intro = "New Tehri, built overlooking the vast emerald waters of Tehri Dam lake—one of Asia's largest hydroelectric reservoirs—has rapidly emerged as a hub for aquatic adventure sports including jet skiing, speed boating, kayaking, and floating houseboats. A self-drive car lets you explore the lakeside, loop across Chamba, Dhanaulti, and Rishikesh, and access remote Garhwal villages at your own pace."
        PickupPoints = @("New Tehri Main Market", "Koti Colony Water Sports Base", "Chamba Town Junction", "Dehradun / Rishikesh Bases (2-hour drive)")
        RecommendedVehicles = "The **Hyundai Venue (₹2,500/day)** and **Kia Sonet (₹3,500/day)** offer nimble handling along the ridge curves between Chamba and New Tehri. The **Mahindra Scorpio N (₹5,500/day)** provides dominating presence for extended outstation loops."
        NearbyAttractions = @(
            @{ Name = "Tehri Lake Water Sports Complex"; Dist = "Koti Colony, 15 km" },
            @{ Name = "Tehri Dam Viewpoint & Hydro Plant"; Dist = "Old Tehri Gorge" },
            @{ Name = "Chamba Himalayan View Junction"; Dist = "11 km west of New Tehri" },
            @{ Name = "Sem Mukhem Nagaraja Temple"; Dist = "64 km pilgrim trek route" }
        )
        Faqs = @(
            @{ Q = "How far is Tehri Lake from Rishikesh and Dehradun?"; A = "Tehri Lake is approx. 85 km from Rishikesh (2.5 hours via NH-94) and approx. 110 km from Dehradun via Mussoorie-Chamba." }
        )
    },
    @{
        Slug = "ranikhet"
        CityName = "Ranikhet"
        Title = "Self Drive Car Rental in Ranikhet | Kumaon Military Cantonment & Golf"
        MetaDesc = "Hire self drive cars in Ranikhet starting at ₹2,200/day. Discover Chaubatia Orchards, Golf Course, and Majkhali. 200 KM daily allowance. Call +91 8923665501."
        H1 = "Self Drive Car Rental in Ranikhet"
        Tagline = "High Altitude Golf Course, Fruit Orchards & Kumaon Regiment Charm"
        Intro = "Ranikhet ('Queen's Meadow') at an elevation of 6,000 feet is an idyllic hill retreat in Almora district famed for its high-altitude 9-hole golf course, British-era stone churches, terraced apple orchards at Chaubatia, and breathtaking views of the Trishul and Nanda Devi peaks. Self-driving gives you seamless connectivity between Ranikhet, Majkhali, Dwarahat temples, and Almora."
        PickupPoints = @("Ranikhet Mall Road & Cantonment", "Kathgodam Railhead Pickup", "Dehradun Base (All-Uttarakhand Touring)", "Pantnagar Airport")
        RecommendedVehicles = "The **Maruti Swift Dzire (₹2,500/day)** and **Toyota Glanza (₹2,200/day)** are exceptionally smooth for the pine-lined roads of Ranikhet. For family travel, the **Maruti Ertiga (₹3,500/day)** is ideal."
        NearbyAttractions = @(
            @{ Name = "Ranikhet Golf Course (Upat)"; Dist = "5 km from town" },
            @{ Name = "Chaubatia Apple & Fruit Orchards"; Dist = "10 km south" },
            @{ Name = "Majkhali Panoramic Viewpoint"; Dist = "12 km on Almora Road" },
            @{ Name = "Jhula Devi Temple & Hundreds of Bells"; Dist = "7 km on Chaubatia Road" }
        )
        Faqs = @(
            @{ Q = "What is the best route to drive to Ranikhet?"; A = "From Kathgodam/Haldwani: Kathgodam -> Bhowali -> Khairna -> Ranikhet (approx. 80 km, 3 hours drive)." }
        )
    },
    @{
        Slug = "almora"
        CityName = "Almora"
        Title = "Self Drive Car Rental in Almora & Kausani | Cultural Capital of Kumaon"
        MetaDesc = "Rent a self drive car in Almora, Kausani & Binsar. 200 KM daily allowance, transparent rates. Book online / WhatsApp: +91 8923665501."
        H1 = "Self Drive Car Rental in Almora"
        Tagline = "Heritage Bazaars, Binsar Wildlife Sanctuary & Kausani Sunrises"
        Intro = "Almora, shaped like a horse saddle along a 5 km mountain ridge, is the cultural heartland of Kumaon. Surrounded by dense oak and rhododendron forests, it offers access to the Binsar Wildlife Sanctuary, Kasar Devi (famous for the Van Allen radiation belt), ancient Jageshwar Dham temple complex (124 stone temples), and the tea gardens of Kausani. A self-drive car is the most practical way to explore these dispersed cultural and natural wonders."
        PickupPoints = @("Almora Mall Road & Bus Station", "Kasar Devi & Binsar Road", "Kathgodam Railhead (90 km)", "Dehradun Base")
        RecommendedVehicles = "For visiting Jageshwar Dham and Binsar wildlife forest trails, the **Hyundai Venue (₹2,500/day)** and **Mahindra Scorpio N (₹5,500/day)** provide the perfect ground clearance and passenger comfort."
        NearbyAttractions = @(
            @{ Name = "Jageshwar Dham (124 Stone Temples)"; Dist = "36 km through deodar valley" },
            @{ Name = "Binsar Wildlife Sanctuary (Zero Point)"; Dist = "30 km north of Almora" },
            @{ Name = "Kasar Devi Temple & Hippie Hill"; Dist = "8 km on Binsar Road" },
            @{ Name = "Kausani Tea Estates & Sunset View"; Dist = "52 km via Someshwar" },
            @{ Name = "Katarmal Sun Temple (9th Century)"; Dist = "17 km from Almora" }
        )
        Faqs = @(
            @{ Q = "Is the road to Jageshwar Dham suitable for self-drive hatchbacks?"; A = "Yes, the road from Almora to Jageshwar Dham is well-paved and scenic. All our hatchbacks, sedans, and SUVs handle it comfortably." }
        )
    },
    @{
        Slug = "roorkee"
        CityName = "Roorkee"
        Title = "Self Drive Car Rental in Roorkee | IIT Roorkee & Highway Delivery"
        MetaDesc = "Book self drive car rentals in Roorkee starting at ₹2,200/day. Fast delivery at IIT Roorkee, Railway Station, and Delhi-Haridwar Highway. Call +91 8923665501."
        H1 = "Self Drive Car Rental in Roorkee"
        Tagline = "Asia's Oldest Engineering Seat, Solani Aqueduct & Industrial Highway"
        Intro = "Roorkee is a prominent educational, industrial, and transit hub located along the Delhi-Haridwar-Dehradun expressway. Home to IIT Roorkee and Central Building Research Institute (CBRI), it connects travellers heading towards Haridwar, Rishikesh, and the Himalayan foothills. Rent a self-drive car for campus visits, business meetings, or seamless onward journeys into Uttarakhand."
        PickupPoints = @("IIT Roorkee Main Gate / Century Gate", "Roorkee Railway Station Platform Exit", "Delhi-Haridwar National Highway NH-334", "Civil Lines & Industrial Corridor")
        RecommendedVehicles = "The **Maruti Swift Dzire (₹2,500/day)** and **Hyundai i20 Automatic (₹3,000/day)** are ideal for highway commuters, faculty, and visiting researchers seeking comfortable, fuel-efficient city and highway transit."
        NearbyAttractions = @(
            @{ Name = "Solani Aqueduct & Ganga Canal"; Dist = "Roorkee landmark" },
            @{ Name = "Piran Kaliyar Sharif Dargah"; Dist = "10 km from Roorkee" },
            @{ Name = "Haridwar Holy Ghats"; Dist = "30 km via 4-lane highway" },
            @{ Name = "Dehradun Capital City"; Dist = "68 km via Mohand Pass" }
        )
        Faqs = @(
            @{ Q = "Can I pick up the car in Roorkee and drive to Dehradun or Delhi?"; A = "Yes! You can take our rental vehicles anywhere across Uttarakhand and neighboring states with standard permit compliance." }
        )
    },
    @{
        Slug = "rudrapur"
        CityName = "Rudrapur"
        Title = "Self Drive Car Rental in Rudrapur & Pantnagar | Industrial Corridor"
        MetaDesc = "Rent a self drive car in Rudrapur & Pantnagar Airport (PGH). Transparent per-day pricing, 200 KM daily allowance. WhatsApp: +91 8923665501."
        H1 = "Self Drive Car Rental in Rudrapur"
        Tagline = "SIDCUL Manufacturing Hub, Pantnagar Airport & Tarai Business Gateway"
        Intro = "Rudrapur, the administrative headquarters of Udham Singh Nagar district, is Uttarakhand's primary industrial and manufacturing nerve center, hosting hundreds of multinational manufacturing plants in SIDCUL. Together with nearby Pantnagar Airport (PGH), it is a key destination for corporate executives, business delegates, and travellers heading onwards to Nainital and Corbett."
        PickupPoints = @("Pantnagar Airport (PGH) Terminal Delivery", "SIDCUL Rudrapur Industrial Area", "Rudrapur City Railway Station", "Kashipur-Rudrapur Highway Hotels")
        RecommendedVehicles = "For corporate travel and client visits, the **Toyota Glanza (₹2,200/day)** and **Hyundai i20 Automatic (₹3,000/day)** deliver executive styling and automatic comfort. For group factory inspections, the **Maruti Ertiga (₹3,500/day)** is the top choice."
        NearbyAttractions = @(
            @{ Name = "Atariya Temple"; Dist = "2 km from Rudrapur bus stand" },
            @{ Name = "Nanakmatta Gurudwara & Dam"; Dist = "35 km on Sitarganj Road" },
            @{ Name = "Nainital Hill Station"; Dist = "70 km via Haldwani" },
            @{ Name = "Jim Corbett National Park"; Dist = "78 km via Kashipur" }
        )
        Faqs = @(
            @{ Q = "Do you deliver cars at Pantnagar Airport?"; A = "Yes, we coordinate airport handover at Pantnagar Airport (PGH) timed with scheduled regional flights." }
        )
    },
    @{
        Slug = "kashipur"
        CityName = "Kashipur"
        Title = "Self Drive Car Rental in Kashipur | Corbett & Industrial Transit"
        MetaDesc = "Hire self drive cars in Kashipur starting at ₹2,200/day. Convenient pickup for Jim Corbett, IIM Kashipur, and industrial visits. 200 KM/day limit. Call +91 8923665501."
        H1 = "Self Drive Car Rental in Kashipur"
        Tagline = "IIM Kashipur Campus, Historical Drona Sagar & Corbett Route Hub"
        Intro = "Kashipur is a historic town and thriving industrial node in Udham Singh Nagar, home to the premier Indian Institute of Management (IIM Kashipur) and close to Jim Corbett National Park in Ramnagar (only 30 km away). Having a self-drive rental car enables effortless transit for students, visiting faculty, business professionals, and tourists traveling between Delhi, Moradabad, Kashipur, and the Corbett wilderness."
        PickupPoints = @("IIM Kashipur Campus Entrance", "Kashipur Railway Station", "Ramnagar Road Corbett Junction", "Aliganj Road Industrial Area")
        RecommendedVehicles = "The **Maruti Baleno (₹2,200/day)** and **Maruti Swift Dzire (₹2,500/day)** provide economical and reliable connectivity. For jungle weekend trips to Ramnagar/Corbett, the **Mahindra Thar (₹5,000/day)** is the standout favorite."
        NearbyAttractions = @(
            @{ Name = "Drona Sagar Lake & Archaeological Site"; Dist = "2 km from city" },
            @{ Name = "Chaiti Devi Temple (Mata Balasundari)"; Dist = "2.5 km on Kashipur-Bajpur Road" },
            @{ Name = "Jim Corbett National Park (Ramnagar)"; Dist = "30 km north" }
        )
        Faqs = @(
            @{ Q = "How far is Jim Corbett National Park from Kashipur?"; A = "Jim Corbett (Ramnagar) is only 30 km (approx. 45 minutes drive) from Kashipur along the smooth NH-309." }
        )
    },
    @{
        Slug = "kotdwar"
        CityName = "Kotdwar"
        Title = "Self Drive Car Rental in Kotdwar | Gateway to Garhwal & Lansdowne"
        MetaDesc = "Self drive car rentals in Kotdwar Railway Station. Seamless road trips to Lansdowne, Pauri, and Bironkhal with 200 KM daily allowance. WhatsApp: +91 8923665501."
        H1 = "Self Drive Car Rental in Kotdwar"
        Tagline = "The Gateway of Garhwal & Railhead for Pauri Garhwal Hill District"
        Intro = "Kotdwar, situated on the banks of the Khoh River at the base of the Shivalik range, is the primary railhead and gateway to the district of Pauri Garhwal. Travellers arriving by train at Kotdwar can pick up a self-drive car to ascend the scenic winding ghat roads to Lansdowne (40 km), Tarkeshwar Mahadev, Pauri town, Srinagar Garhwal, and the inner valleys of Uttarakhand."
        PickupPoints = @("Kotdwar Railway Station (Railhead Delivery)", "Kotdwar Bus Station & Najibabad Road", "Kishanpur & Ratanpur Junctions")
        RecommendedVehicles = "For the 40 km hill climb from Kotdwar to Lansdowne, the **Hyundai Venue (₹2,500/day)** and **Maruti Swift Dzire (₹2,500/day)** provide responsive steering and excellent hill manners."
        NearbyAttractions = @(
            @{ Name = "Sidhbali Hanuman Temple"; Dist = "2 km on Khoh river bank" },
            @{ Name = "Kanvashram Historic Forest Hermitage"; Dist = "14 km along Malini River" },
            @{ Name = "Lansdowne Cantonment Hill Station"; Dist = "40 km scenic hill drive" }
        )
        Faqs = @(
            @{ Q = "Can we book a car for pickup at Kotdwar Railway Station for Lansdowne?"; A = "Yes, we arrange prompt station handover at Kotdwar for direct self-drive to Lansdowne resorts." }
        )
    },
    @{
        Slug = "uttarkashi"
        CityName = "Uttarkashi"
        Title = "Self Drive Car Rental in Uttarkashi | Gangotri & Yamunotri Pilgrimage"
        MetaDesc = "Rent a self drive car in Uttarkashi for Gangotri, Yamunotri, and Char Dham Yatra. Heavy duty 4x4 SUVs and 7-seaters. 200 KM daily limit. Call: +91 8923665501."
        H1 = "Self Drive Car Rental in Uttarkashi"
        Tagline = "Sacred Bhagirathi Valley, NIM Mountaineering Hub & Gangotri Portal"
        Intro = "Uttarkashi ('Kashi of the North'), situated on the banks of the sacred Bhagirathi River at an elevation of 3,799 feet, is home to the ancient Vishwanath Temple and the prestigious Nehru Institute of Mountaineering (NIM). It serves as the primary base for pilgrimage to Gangotri Dham and Gaumukh glacier, as well as trekking expeditions into Har Ki Dun, Dayara Bugyal, and Dodital. A self-drive SUV delivers the reliability and comfort required for high-mountain pilgrimages."
        PickupPoints = @("Dehradun Base (Recommended start for Uttarkashi highway)", "Uttarkashi Main Town & Bus Station", "Rishikesh Yog Nagari Hub")
        RecommendedVehicles = "The mountain route along the Bhagirathi gorge calls for high-ground-clearance vehicles like the **Mahindra Scorpio N (₹5,500/day)** and **Mahindra Thar 4x4 (₹5,000/day)**. For family yatris, the **Maruti Ertiga (₹3,500/day)** offers comfortable 7-passenger capacity."
        NearbyAttractions = @(
            @{ Name = "Kashi Vishwanath Temple Uttarkashi"; Dist = "Town Centre" },
            @{ Name = "Gangotri Dham (Origin of Ganga)"; Dist = "99 km via Harshil Valley" },
            @{ Name = "Harshil Valley & Apple Orchards"; Dist = "73 km on Gangotri Highway" },
            @{ Name = "Dayara Bugyal Alpine Meadow"; Dist = "40 km to base at Barsu" }
        )
        Faqs = @(
            @{ Q = "What is the driving distance from Dehradun to Uttarkashi?"; A = "Dehradun to Uttarkashi is approx. 145 km via Mussoorie-Suwakholi-Chinyalisaur (approx. 5 to 6 hours drive through scenic mountain roads)." }
        )
    },
    @{
        Slug = "srinagar-garhwal"
        CityName = "Srinagar Garhwal"
        Title = "Self Drive Car Rental in Srinagar Garhwal | Alaknanda Valley & Char Dham"
        MetaDesc = "Self drive car rentals in Srinagar Garhwal along NH-07. Connect to Badrinath, Kedarnath, Pauri & HNBGU campus. 200 KM daily limit. Call: +91 8923665501."
        H1 = "Self Drive Car Rental in Srinagar Garhwal"
        Tagline = "Alaknanda River Valley, HNBGU University & Char Dham Highway Crossroads"
        Intro = "Srinagar Garhwal, the largest city in the Garhwal hills situated along the wide banks of the Alaknanda River, is a major cultural, educational (HNB Garhwal Central University & Medical College), and transit hub along the all-weather National Highway NH-07. Serving as a key junction connecting Rishikesh, Pauri, Rudraprayag, Kedarnath, and Badrinath, having a self-drive car gives you total freedom on highway journeys."
        PickupPoints = @("Srinagar Garhwal Bus Station & Alaknanda Bridge", "HNBGU Central University Campus", "Dehradun / Rishikesh Hubs (Onward drive)")
        RecommendedVehicles = "The **Maruti Swift Dzire (₹2,500/day)** and **Kia Sonet (₹3,500/day)** cruise smoothly along the 4-lane all-weather highway. For long multi-day pilgrim itineraries, the **Mahindra Scorpio N (₹5,500/day)** is the top choice."
        NearbyAttractions = @(
            @{ Name = "Kamleshwar Mahadev Temple"; Dist = "Srinagar town" },
            @{ Name = "Dhari Devi Temple (Guardian Deity of Char Dham)"; Dist = "14 km towards Rudraprayag" },
            @{ Name = "Pauri Hill Town & Panoramic Views"; Dist = "29 km mountain climb" },
            @{ Name = "Devprayag Sangam (Bhagirathi + Alaknanda)"; Dist = "35 km towards Rishikesh" }
        )
        Faqs = @(
            @{ Q = "Can we visit Dhari Devi Temple with your rental car?"; A = "Yes, Dhari Devi Temple is conveniently situated right along NH-07 just 14 km from Srinagar Garhwal with easy roadside parking." }
        )
    },
    @{
        Slug = "chamoli"
        CityName = "Chamoli"
        Title = "Self Drive Car Rental in Chamoli & Joshimath | Badrinath & Valley of Flowers"
        MetaDesc = "Rent heavy duty self drive SUVs for Chamoli, Joshimath, Badrinath, and Hemkund Sahib. 200 KM daily allowance. Call / WhatsApp: +91 8923665501."
        H1 = "Self Drive Car Rental in Chamoli"
        Tagline = "Alaknanda Canyons, High Himalayan Passes & Holy Badrinath Gateway"
        Intro = "Chamoli district is the majestic heartland of the upper Garhwal Himalayas, home to Badrinath Dham, the UNESCO World Heritage Valley of Flowers, Hemkund Sahib, Auli, and the Panch Prayag confluences. Embarking on a self-drive road trip through Chamoli offers an awe-inspiring drive through deep river gorges, alpine meadows, and snow-capped peaks with complete control over your travel schedule."
        PickupPoints = @("Dehradun Base (Standard Yatra start)", "Rishikesh Railhead Hub", "Chamoli & Gopeshwar Towns", "Joshimath Base")
        RecommendedVehicles = "High mountain passes and long distances require rugged power. We strongly advise the **Mahindra Scorpio N Diesel (₹5,500/day)**, **Mahindra Thar 4x4 (₹5,000/day)**, or **Maruti Ertiga 7-Seater (₹3,500/day)**."
        NearbyAttractions = @(
            @{ Name = "Badrinath Dham Holy Temple"; Dist = "Upper Chamoli via Joshimath" },
            @{ Name = "Valley of Flowers & Hemkund Base (Govindghat)"; Dist = "20 km past Joshimath" },
            @{ Name = "Mana Village (First Village of India)"; Dist = "3 km beyond Badrinath" },
            @{ Name = "Gopeshwar Gopinath Temple"; Dist = "10 km from Chamoli town" }
        )
        Faqs = @(
            @{ Q = "Is all-weather road open to Chamoli and Badrinath?"; A = "Yes, the NH-07 Char Dham all-weather highway provides wide, well-engineered roads up to Joshimath and Badrinath." }
        )
    },
    @{
        Slug = "bageshwar"
        CityName = "Bageshwar"
        Title = "Self Drive Car Rental in Bageshwar | Saryu-Gomti Sangam & Kumaon"
        MetaDesc = "Rent a self drive car in Bageshwar. Visit Bagnath Temple, Baijnath, and Pindari Glacier base with 200 KM daily allowance. WhatsApp: +91 8923665501."
        H1 = "Self Drive Car Rental in Bageshwar"
        Tagline = "Sacred Confluence of Saryu & Gomti, Ancient Temples & Glacial Treks"
        Intro = "Bageshwar, situated at the holy confluence of the Saryu and Gomti rivers, is renowned for the 7th-century Bagnath Temple, Baijnath temple complex, and as the trailhead for high-altitude treks to Pindari, Sunderdhunga, and Kafni glaciers. Self-driving through Bageshwar allows you to explore Kausani's tea gardens, Baijnath stone sculptures, and the untouched valleys of Kumaon at your leisure."
        PickupPoints = @("Bageshwar Town Market", "Kathgodam Railhead (150 km)", "Dehradun Hub", "Kausani Junction")
        RecommendedVehicles = "The **Hyundai Venue (₹2,500/day)**, **Maruti Swift Dzire (₹2,500/day)**, and **Mahindra Scorpio N (₹5,500/day)** provide comfortable suspension for the rolling Kumaon hill highways."
        NearbyAttractions = @(
            @{ Name = "Bagnath Shiva Temple (7th Century)"; Dist = "Confluence in town" },
            @{ Name = "Baijnath 12th-Century Stone Temple Complex"; Dist = "21 km towards Kausani" },
            @{ Name = "Kausani Sunset Point & Tea Estates"; Dist = "38 km scenic drive" },
            @{ Name = "Pindari Glacier Trek Base (Song/Loharkhet)"; Dist = "40 km mountain road" }
        )
        Faqs = @(
            @{ Q = "How do I reach Bageshwar from Dehradun or Delhi?"; A = "Drive via Haldwani -> Bhowali -> Almora -> Bageshwar (or via Karnaprayag -> Gwaldam -> Bageshwar)." }
        )
    },
    @{
        Slug = "pithoragarh"
        CityName = "Pithoragarh"
        Title = "Self Drive Car Rental in Pithoragarh | Sohr Valley & Munsiyari Base"
        MetaDesc = "Rent self-drive cars for Pithoragarh, Munsiyari, and Panchachuli peaks. Heavy duty SUVs and sedans with 200 KM daily allowance. Call +91 8923665501."
        H1 = "Self Drive Car Rental in Pithoragarh"
        Tagline = "The Little Kashmir of Uttarakhand, Sohr Valley & Himalayan Passages"
        Intro = "Pithoragarh, nestled in the picturesque bowl-shaped Sohr Valley bordered by snow-capped peaks, is Uttarakhand's easternmost frontier district. Famous for Pithoragarh Fort, Chandak viewpoint, Thal Kedar, and as the gateway to Munsiyari (with close-up views of the Panchachuli peaks), a self-drive SUV gives you the power and endurance to explore these majestic Himalayan landscapes."
        PickupPoints = @("Pithoragarh Town & Naini Saini Airport Area", "Kathgodam Railhead Base", "Dehradun Hub (Full Uttarakhand Tour)")
        RecommendedVehicles = "The rugged **Mahindra Scorpio N Diesel (₹5,500/day)** and **Mahindra Thar 4x4 (₹5,000/day)** are highly recommended for the dramatic highland passes leading up to Munsiyari and Dharchula."
        NearbyAttractions = @(
            @{ Name = "Pithoragarh Historic Fort (Gorkha Fort)"; Dist = "Town Centre" },
            @{ Name = "Chandak Hill Viewpoint & Mostamanu"; Dist = "7 km scenic drive" },
            @{ Name = "Munsiyari Panchachuli Panorama"; Dist = "125 km mountain highway" },
            @{ Name = "Jhula Ghat (Nepal Border Bridge)"; Dist = "36 km south" }
        )
        Faqs = @(
            @{ Q = "Is 4x4 required for driving to Pithoragarh and Munsiyari?"; A = "While standard SUVs and sedans reach Pithoragarh comfortably, our high-clearance SUVs (Scorpio N / Thar) provide maximum safety and confidence on the high-altitude Birthi Falls / Munsiyari route." }
        )
    }
)

function Generate-LocationPage ($loc) {
    $slug = $loc.Slug
    $city = $loc.CityName
    $title = $loc.Title
    $desc = $loc.MetaDesc
    $h1 = $loc.H1
    $tagline = $loc.Tagline
    $intro = $loc.Intro
    $recVehicles = $loc.RecommendedVehicles
    
    # Pickup points HTML
    $pickupsHtml = ""
    foreach ($p in $loc.PickupPoints) {
        $pickupsHtml += "<li style='margin-bottom:0.4rem;'>📍 $p</li>"
    }

    # Attractions HTML
    $attractionsHtml = ""
    foreach ($a in $loc.NearbyAttractions) {
        $aName = $a.Name
        $aDist = $a.Dist
        $attractionsHtml += @"
        <div style="background:var(--bg-card); padding:1rem 1.25rem; border-radius:var(--radius-md); border:1px solid var(--border);">
          <strong style="color:var(--text-main); display:block; margin-bottom:0.2rem;">$aName</strong>
          <small style="color:var(--text-muted);">$aDist</small>
        </div>
"@
    }

    # FAQ HTML & Schema
    $faqHtml = ""
    $faqSchemaItems = @()
    foreach ($f in $loc.Faqs) {
        $q = $f.Q
        $ans = $f.A
        $faqHtml += @"
        <div class="faq-item">
          <button class="faq-question">
            <span>$q</span>
            <span class="faq-icon">▼</span>
          </button>
          <div class="faq-answer">$ans</div>
        </div>
"@
        $faqSchemaItems += @"
        {
          "@type": "Question",
          "name": "$q",
          "acceptedAnswer": {
            "@type": "Answer",
            "text": "$ans"
          }
        }
"@
    }
    $faqSchemaJson = $faqSchemaItems -join ","

    $html = @"
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  
  <title>$title</title>
  <meta name="description" content="$desc">
  <link rel="canonical" href="https://car-rental-dehradun.com/locations/$slug.html">

  <meta property="og:type" content="website">
  <meta property="og:url" content="https://car-rental-dehradun.com/locations/$slug.html">
  <meta property="og:title" content="$title">
  <meta property="og:description" content="$desc">
  <meta property="og:image" content="https://car-rental-dehradun.com/images/icons/icon-512.png">

  <link rel="manifest" href="../manifest.webmanifest">
  <meta name="theme-color" content="#0f766e">
  <link rel="icon" type="image/png" href="../images/icons/icon-192.png">

  <link rel="stylesheet" href="../css/style.css">
  <link rel="stylesheet" href="../css/components.css">

  <script type="application/ld+json">
  {
    "@context": "https://schema.org",
    "@type": "AutoRental",
    "name": "Car Rental Dehradun - $city Service",
    "url": "https://car-rental-dehradun.com/locations/$slug.html",
    "telephone": "+91-8923665501",
    "description": "$desc",
    "priceRange": "₹₹",
    "areaServed": {
      "@type": "City",
      "name": "$city"
    }
  }
  </script>

  <script type="application/ld+json">
  {
    "@context": "https://schema.org",
    "@type": "BreadcrumbList",
    "itemListElement": [
      {
        "@type": "ListItem",
        "position": 1,
        "name": "Home",
        "item": "https://car-rental-dehradun.com/"
      },
      {
        "@type": "ListItem",
        "position": 2,
        "name": "Locations",
        "item": "https://car-rental-dehradun.com/locations/index.html"
      },
      {
        "@type": "ListItem",
        "position": 3,
        "name": "$city",
        "item": "https://car-rental-dehradun.com/locations/$slug.html"
      }
    ]
  }
  </script>

  <script type="application/ld+json">
  {
    "@context": "https://schema.org",
    "@type": "FAQPage",
    "mainEntity": [
      $faqSchemaJson
    ]
  }
  </script>
</head>
<body>

  <!-- Site Header -->
  <header class="site-header">
    <div class="container header-container">
      <a href="../index.html" class="brand-logo">
        <div class="logo-icon">🚗</div>
        <div>Car Rental <span class="highlight">Dehradun</span></div>
      </a>

      <nav class="nav-links">
        <a href="../index.html">Home</a>
        <a href="../cars.html">Our Cars</a>
        <a href="index.html" class="active">Locations</a>
        <a href="../destinations/index.html">Destinations</a>
        <a href="../travel-guides/index.html">Travel Guides</a>
        <a href="../book.html">Book Now</a>
        <a href="../contact.html">Contact</a>
      </nav>

      <div class="header-actions">
        <a href="tel:+918923665501" class="header-phone-btn">
          <span>📞</span>
          <span class="phone-text">+91 8923665501</span>
        </a>
        <a href="https://wa.me/918923665501?text=Hello%20Car%20Rental%20Dehradun,%20I%20want%20to%20rent%20a%20car%20in%20$city." target="_blank" rel="noopener" class="btn btn-whatsapp btn-sm">
          <span>💬 WhatsApp</span>
        </a>
        <button class="mobile-menu-toggle" id="mobileMenuToggle" aria-label="Open Menu">
          <span></span><span></span><span></span>
        </button>
      </div>
    </div>
  </header>

  <!-- Mobile Navigation Drawer -->
  <div class="mobile-nav-drawer" id="mobileNavDrawer">
    <div class="mobile-nav-content">
      <a href="../index.html">🏠 Home</a>
      <a href="../cars.html">🚗 Our Cars & Pricing</a>
      <a href="index.html" class="active">📍 Rental Locations</a>
      <a href="../destinations/index.html">⛰️ Destinations</a>
      <a href="../travel-guides/index.html">📖 Travel Guides</a>
      <a href="../book.html">📅 Book a Car</a>
      <a href="../terms.html">📋 Rental Terms</a>
      <a href="../contact.html">📞 Contact Us</a>
    </div>
  </div>

  <!-- Breadcrumbs Navigation -->
  <div style="background:var(--bg-alt); padding:0.75rem 0; border-bottom:1px solid var(--border); font-size:0.88rem;">
    <div class="container">
      <a href="../index.html" style="color:var(--primary)">Home</a> / 
      <a href="index.html" style="color:var(--primary)">Locations</a> / 
      <span style="color:var(--text-muted)">$city Car Rental</span>
    </div>
  </div>

  <!-- Hero Header Banner -->
  <section style="background:linear-gradient(135deg, #042f2e, #0f766e); color:#fff; padding:3.5rem 0; text-align:center;">
    <div class="container" style="max-width:850px;">
      <span class="hero-badge">⛰️ Uttarakhand Self-Drive Network • 200 KM / Day Allowance</span>
      <h1 style="color:#fff; margin-bottom:0.75rem;">$h1</h1>
      <p style="color:#ccfbf1; font-size:1.15rem; margin-bottom:1.75rem;">$tagline</p>
      <div style="display:flex; justify-content:center; gap:1rem; flex-wrap:wrap;">
        <a href="../book.html?pickup_loc=$city" class="btn btn-accent btn-lg">Book Car in $city ➔</a>
        <a href="https://wa.me/918923665501?text=Hello%20Car%20Rental%20Dehradun,%20I%20want%20to%20book%20a%20self%20drive%20car%20in%20$city." target="_blank" rel="noopener" class="btn btn-whatsapp btn-lg">💬 WhatsApp +91 8923665501</a>
        <a href="tel:+918923665501" class="btn btn-call btn-lg">📞 Call Now</a>
      </div>
    </div>
  </section>

  <!-- Location Overview & Booking Content -->
  <main class="section">
    <div class="container" style="max-width:950px;">
      
      <!-- Intro Article -->
      <div style="background:var(--bg-card); padding:2.5rem; border-radius:var(--radius-lg); border:1px solid var(--border); box-shadow:var(--shadow-sm); line-height:1.8; color:var(--text-muted); margin-bottom:2.5rem;">
        <h2 style="color:var(--text-main); font-size:1.5rem; margin-bottom:1rem;">Car Rental & Self-Drive Services in $city</h2>
        <p style="margin-bottom:1.5rem; font-size:1.02rem;">$intro</p>

        <h3 style="color:var(--text-main); font-size:1.25rem; margin:1.5rem 0 0.75rem;">Key Pickup & Handover Points in $city</h3>
        <ul style="padding-left:1.5rem; margin-bottom:1.75rem;">
          $pickupsHtml
        </ul>

        <h3 style="color:var(--text-main); font-size:1.25rem; margin:1.5rem 0 0.75rem;">Recommended Rental Vehicles for $city & Hills</h3>
        <p style="margin-bottom:1.5rem;">$recVehicles</p>
      </div>

      <!-- Pricing Summary Cards -->
      <div style="margin-bottom:2.5rem;">
        <div class="section-header" style="text-align:left; margin-bottom:1.5rem;">
          <span class="section-badge">Transparent Pricing</span>
          <h2 style="font-size:1.5rem;">Popular Self-Drive Rates for $city</h2>
        </div>

        <div style="display:grid; grid-template-columns:repeat(auto-fit, minmax(260px, 1fr)); gap:1.25rem;">
          <div class="feature-card">
            <h4>Maruti Swift Dzire</h4>
            <p style="font-size:0.85rem; color:var(--primary); font-weight:600;">Sedan • Manual • Petrol • 5 Seats</p>
            <div style="font-size:1.5rem; font-weight:800; color:var(--primary-dark); margin:0.5rem 0;">₹2,500 / day</div>
            <p style="font-size:0.85rem;">200 KM daily allowance included. Best for hill touring & economy.</p>
            <a href="../book.html?car=car-swift-dzire&pickup_loc=$city" class="btn btn-primary btn-sm btn-block" style="margin-top:0.75rem;">Book Dzire</a>
          </div>

          <div class="feature-card">
            <h4>Maruti Ertiga (7-Seater)</h4>
            <p style="font-size:0.85rem; color:var(--primary); font-weight:600;">MUV • Manual • Petrol • 7 Seats</p>
            <div style="font-size:1.5rem; font-weight:800; color:var(--primary-dark); margin:0.5rem 0;">₹3,500 / day</div>
            <p style="font-size:0.85rem;">200 KM daily allowance. Independent rear AC for group tours.</p>
            <a href="../book.html?car=car-ertiga&pickup_loc=$city" class="btn btn-primary btn-sm btn-block" style="margin-top:0.75rem;">Book Ertiga</a>
          </div>

          <div class="feature-card">
            <h4>Mahindra Scorpio N</h4>
            <p style="font-size:0.85rem; color:var(--primary); font-weight:600;">SUV • Turbo Diesel • 7 Seats</p>
            <div style="font-size:1.5rem; font-weight:800; color:var(--primary-dark); margin:0.5rem 0;">₹5,500 / day</div>
            <p style="font-size:0.85rem;">Heavy duty diesel torque & high ground clearance for rugged mountains.</p>
            <a href="../book.html?car=car-scorpio-n&pickup_loc=$city" class="btn btn-primary btn-sm btn-block" style="margin-top:0.75rem;">Book Scorpio N</a>
          </div>

          <div class="feature-card">
            <h4>Mahindra Thar 4x4</h4>
            <p style="font-size:0.85rem; color:var(--primary); font-weight:600;">4x4 SUV • Diesel • 4 Seats</p>
            <div style="font-size:1.5rem; font-weight:800; color:var(--primary-dark); margin:0.5rem 0;">₹5,000 / day</div>
            <p style="font-size:0.85rem;">The ultimate lifestyle adventure off-roader for Himalayan roads.</p>
            <a href="../book.html?car=car-thar&pickup_loc=$city" class="btn btn-primary btn-sm btn-block" style="margin-top:0.75rem;">Book Thar</a>
          </div>
        </div>
      </div>

      <!-- Nearby Attractions Grid -->
      <div style="margin-bottom:2.5rem;">
        <div class="section-header" style="text-align:left; margin-bottom:1.5rem;">
          <span class="section-badge">Sightseeing Routes</span>
          <h2 style="font-size:1.5rem;">Top Destinations to Explore Around $city</h2>
        </div>
        <div style="display:grid; grid-template-columns:repeat(auto-fit, minmax(220px, 1fr)); gap:1rem;">
          $attractionsHtml
        </div>
      </div>

      <!-- FAQ Section -->
      <div style="margin-bottom:2.5rem;">
        <div class="section-header" style="text-align:left; margin-bottom:1.5rem;">
          <span class="section-badge">Frequently Asked Questions</span>
          <h2 style="font-size:1.5rem;">$city Car Rental FAQs</h2>
        </div>
        <div class="faq-list">
          $faqHtml
        </div>
      </div>

      <!-- Conversion CTA Card -->
      <div style="background:linear-gradient(135deg, #042f2e, #0f766e); color:#fff; padding:2.5rem; border-radius:var(--radius-lg); text-align:center;">
        <h3 style="color:#fff; font-size:1.6rem; margin-bottom:0.75rem;">Ready to Book Your Self-Drive Car in $city?</h3>
        <p style="color:#ccfbf1; font-size:1.05rem; max-width:650px; margin:0 auto 1.5rem;">
          Clean, sanitized cars with 200 KM daily allowance, zero hidden fees, and 24/7 roadside assistance.
        </p>
        <div style="display:flex; justify-content:center; gap:1rem; flex-wrap:wrap;">
          <a href="../book.html?pickup_loc=$city" class="btn btn-accent btn-lg">Reserve Vehicle Online</a>
          <a href="https://wa.me/918923665501?text=Hello%20Car%20Rental%20Dehradun,%20I%20want%20to%20confirm%20car%20availability%20for%20$city." target="_blank" rel="noopener" class="btn btn-whatsapp btn-lg">💬 WhatsApp +91 8923665501</a>
          <a href="tel:+918923665501" class="btn btn-call btn-lg">📞 Call +91 8923665501</a>
        </div>
      </div>

    </div>
  </main>

  <!-- Footer -->
  <footer class="site-footer">
    <div class="container footer-grid">
      <div class="footer-brand">
        <div class="brand-logo" style="color:#fff;margin-bottom:1rem;">
          <div class="logo-icon">🚗</div>
          <div>Car Rental <span class="highlight">Dehradun</span></div>
        </div>
        <p>Premium self-drive car rentals across Uttarakhand with 200 KM daily allowance and zero hidden charges.</p>
        <p><strong>Website:</strong> <a href="https://car-rental-dehradun.com" style="color:var(--accent)">car-rental-dehradun.com</a></p>
      </div>

      <div class="footer-column">
        <h4>Other Locations</h4>
        <ul class="footer-links">
          <li><a href="dehradun.html">Dehradun</a></li>
          <li><a href="mussoorie.html">Mussoorie</a></li>
          <li><a href="rishikesh.html">Rishikesh</a></li>
          <li><a href="haridwar.html">Haridwar</a></li>
          <li><a href="nainital.html">Nainital</a></li>
          <li><a href="jim-corbett.html">Jim Corbett</a></li>
        </ul>
      </div>

      <div class="footer-column">
        <h4>Quick Links</h4>
        <ul class="footer-links">
          <li><a href="../index.html">Home</a></li>
          <li><a href="../cars.html">Our Fleet</a></li>
          <li><a href="../destinations/index.html">Destinations</a></li>
          <li><a href="../travel-guides/index.html">Travel Guides</a></li>
          <li><a href="../terms.html">Rental Terms</a></li>
          <li><a href="../contact.html">Contact Us</a></li>
        </ul>
      </div>

      <div class="footer-column">
        <h4>Contact & Dispatch</h4>
        <div class="footer-contact-item">
          <span>📞</span>
          <div><a href="tel:+918923665501">+91 8923665501</a></div>
        </div>
        <div class="footer-contact-item">
          <span>💬</span>
          <div><a href="https://wa.me/918923665501" target="_blank" rel="noopener">+91 8923665501</a></div>
        </div>
      </div>
    </div>
    <div class="container footer-bottom">
      <div>&copy; 2026 Car Rental Dehradun • Uttarakhand Self Drive Network</div>
      <div><a href="../admin/login.html" style="color:#64748b;">Admin Portal</a></div>
    </div>
  </footer>

  <div class="mobile-action-bar">
    <a href="https://wa.me/918923665501?text=Hello%20Car%20Rental%20Dehradun,%20I%20want%20to%20rent%20a%20car%20in%20$city." target="_blank" rel="noopener" class="btn btn-whatsapp">
      <span>💬 WhatsApp</span>
    </a>
    <a href="tel:+918923665501" class="btn btn-call">
      <span>📞 Call</span>
    </a>
    <a href="../book.html?pickup_loc=$city" class="btn btn-primary">
      <span>🚗 Book Now</span>
    </a>
  </div>

  <script src="../js/api.js"></script>
  <script src="../js/app.js"></script>
  <script src="../js/pwa.js"></script>
</body>
</html>
"@
    $targetPath = Join-Path $locDir "$slug.html"
    [System.IO.File]::WriteAllText($targetPath, $html, [System.Text.Encoding]::UTF8)
    Write-Host "Generated: locations/$slug.html" -ForegroundColor Green
}

foreach ($loc in $locations) {
    Generate-LocationPage $loc
}

Write-Host "All $($locations.Count) Location Pages Generated Successfully!" -ForegroundColor Cyan
