import 'package:cloud_firestore/cloud_firestore.dart';

final CollectionReference usersCollection =
    FirebaseFirestore.instance.collection('users');

// Method to get the 'recommend_subcategory' value
Future<String> getRecommend(String userId) async {
  try {
    // Get the document snapshot for the specified user
    DocumentSnapshot<Map<String, dynamic>> userSnapshot = await usersCollection
        .doc(userId)
        .get() as DocumentSnapshot<Map<String, dynamic>>;

    // Check if the user exists and has the 'recommend_analysis' field
    if (userSnapshot.exists && userSnapshot.data() != null) {
      // Access the 'recommend_analysis' map
      Map<String, dynamic> recommendAnalysis =
          userSnapshot.data()!['recommend_analysis'] ?? {};

      // Check if the 'recommend_subcategory' field exists in the map
      if (recommendAnalysis.containsKey('recommend_subcategory')) {
        // Return the value of 'recommend_subcategory' as a String
        return recommendAnalysis['recommend_subcategory'] as String;
      }
    }
    // Return an empty string if the user doesn't exist or 'recommend_subcategory' is not found
    return '';
  } catch (e) {
    // Handle any errors that occur during the process
    print('Error getting recommend_subcategory: $e');
    // Return an empty string in case of an error
    return '';
  }
}

Future<void> updateRecommend(String userId, String subcategory) async {
  try {
    // Get the 'users' document reference for the specified user
    DocumentReference userDocRef =
        FirebaseFirestore.instance.collection('users').doc(userId);

    // Fetch the 'recommend_analysis' map from the 'users' document
    DocumentSnapshot<Map<String, dynamic>> userSnapshot =
        await userDocRef.get() as DocumentSnapshot<Map<String, dynamic>>;

    // Check if the document exists and has data
    if (userSnapshot.exists && userSnapshot.data() != null) {
      Map<String, dynamic> recommendAnalysis =
          userSnapshot.data()!['recommend_analysis'] ?? {};

      // Retrieve numeric values for the new attributes
      double accessories = (recommendAnalysis['Accessories'] ?? 0) * 0.9;
      double bedsAndWardrobes =
          (recommendAnalysis['Beds & Wardrobes'] ?? 0) * 0.9;
      double bicycles = (recommendAnalysis['Bicycles'] ?? 0) * 0.9;
      double books = (recommendAnalysis['Books'] ?? 0) * 0.9;
      double camerasAndLenses =
          (recommendAnalysis['Cameras & Lenses'] ?? 0) * 0.9;
      double computersAndLaptops =
          (recommendAnalysis['Computers & Laptops'] ?? 0) * 0.9;
      double forRentHouseAndApartments =
          (recommendAnalysis['For Rent: House & Apartments'] ?? 0) * 0.9;
      double forSaleHouseAndApartments =
          (recommendAnalysis['For Sale: House & Apartments'] ?? 0) * 0.9;
      double fridges = (recommendAnalysis['Fridges'] ?? 0) * 0.9;
      double gamesAndEntertainment =
          (recommendAnalysis['Games & Entertainment'] ?? 0) * 0.9;
      double gymAndFitness = (recommendAnalysis['Gym & Fitness'] ?? 0) * 0.9;
      double homeDecorAndGarden =
          (recommendAnalysis['Home Decor & Garden'] ?? 0) * 0.9;
      double kids = (recommendAnalysis['Kids'] ?? 0) * 0.9;
      double kidsFurniture = (recommendAnalysis['Kids Furniture'] ?? 0) * 0.9;
      double kitchenAppliances =
          (recommendAnalysis['Kitchen Appliances'] ?? 0) * 0.9;
      double men = (recommendAnalysis['Men'] ?? 0) * 0.9;
      double mobilePhones = (recommendAnalysis['Mobile Phones'] ?? 0) * 0.9;
      double motorcycles = (recommendAnalysis['Motorcycles'] ?? 0) * 0.9;
      double musicalInstruments =
          (recommendAnalysis['Musical Instruments'] ?? 0) * 0.9;
      double scooters = (recommendAnalysis['Scooters'] ?? 0) * 0.9;
      double sofaAndDining = (recommendAnalysis['Sofa & Dining'] ?? 0) * 0.9;
      double sportsEquipment =
          (recommendAnalysis['Sports Equipment'] ?? 0) * 0.9;
      double tvs = (recommendAnalysis['TVs'] ?? 0) * 0.9;
      double women = (recommendAnalysis['Women'] ?? 0) * 0.9;
      String recommendSubcategory =
          recommendAnalysis['recommend_subcategory'] ?? 'Mobile Phones';
      double recommendValue =
          (recommendAnalysis['recommend_value'] ?? 0.3) * 0.9;

      // Check if the 'subcategory' matches any of the numeric attributes
      // If yes, increment the attribute value by 1
      switch (subcategory) {
        case 'Accessories':
          accessories += 1;
          if (accessories > recommendValue) {
            recommendSubcategory = 'Accessories';
            recommendValue = accessories;
          }
          break;
        case 'Beds & Wardrobes':
          bedsAndWardrobes += 1;
          if (bedsAndWardrobes > recommendValue) {
            recommendSubcategory = 'Beds & Wardrobes';
            recommendValue = bedsAndWardrobes;
          }
          break;
        case 'Bicycles':
          bicycles += 1;
          if (bicycles > recommendValue) {
            recommendSubcategory = 'Bicycles';
            recommendValue = bicycles;
          }
          break;
        case 'Books':
          books += 1;
          if (books > recommendValue) {
            recommendSubcategory = 'Books';
            recommendValue = books;
          }
          break;
        case 'Cameras & Lenses':
          camerasAndLenses += 1;
          if (camerasAndLenses > recommendValue) {
            recommendSubcategory = 'Cameras & Lenses';
            recommendValue = camerasAndLenses;
          }
          break;
        case 'Computers & Laptops':
          computersAndLaptops += 1;
          if (computersAndLaptops > recommendValue) {
            recommendSubcategory = 'Computers & Laptops';
            recommendValue = computersAndLaptops;
          }
          break;
        case 'For Rent: House & Apartments':
          forRentHouseAndApartments += 1;
          if (forRentHouseAndApartments > recommendValue) {
            recommendSubcategory = 'For Rent: House & Apartments';
            recommendValue = forRentHouseAndApartments;
          }
          break;
        case 'For Sale: House & Apartments':
          forSaleHouseAndApartments += 1;
          if (forSaleHouseAndApartments > recommendValue) {
            recommendSubcategory = 'For Sale: House & Apartments';
            recommendValue = forSaleHouseAndApartments;
          }
          break;
        case 'Fridges':
          fridges += 1;
          if (fridges > recommendValue) {
            recommendSubcategory = 'Fridges';
            recommendValue = fridges;
          }
          break;
        case 'Games & Entertainment':
          gamesAndEntertainment += 1;
          if (gamesAndEntertainment > recommendValue) {
            recommendSubcategory = 'Games & Entertainment';
            recommendValue = gamesAndEntertainment;
          }
          break;
        case 'Gym & Fitness':
          gymAndFitness += 1;
          if (gymAndFitness > recommendValue) {
            recommendSubcategory = 'Gym & Fitness';
            recommendValue = gymAndFitness;
          }
          break;
        case 'Home Decor & Garden':
          homeDecorAndGarden += 1;
          if (homeDecorAndGarden > recommendValue) {
            recommendSubcategory = 'Home Decor & Garden';
            recommendValue = homeDecorAndGarden;
          }
          break;
        case 'Kids':
          kids += 1;
          if (kids > recommendValue) {
            recommendSubcategory = 'Kids';
            recommendValue = kids;
          }
          break;
        case 'Kids Furniture':
          kidsFurniture += 1;
          if (kidsFurniture > recommendValue) {
            recommendSubcategory = 'Kids Furniture';
            recommendValue = kidsFurniture;
          }
          break;
        case 'Kitchen Appliances':
          kitchenAppliances += 1;
          if (kitchenAppliances > recommendValue) {
            recommendSubcategory = 'Kitchen Appliances';
            recommendValue = kitchenAppliances;
          }
          break;
        case 'Men':
          men += 1;
          if (men > recommendValue) {
            recommendSubcategory = 'Men';
            recommendValue = men;
          }
          break;
        case 'Mobile Phones':
          mobilePhones += 1;
          if (mobilePhones > recommendValue) {
            recommendSubcategory = 'Mobile Phones';
            recommendValue = mobilePhones;
          }
          break;
        case 'Motorcycles':
          motorcycles += 1;
          if (motorcycles > recommendValue) {
            recommendSubcategory = 'Motorcycles';
            recommendValue = motorcycles;
          }
          break;
        case 'Musical Instruments':
          musicalInstruments += 1;
          if (musicalInstruments > recommendValue) {
            recommendSubcategory = 'Musical Instruments';
            recommendValue = musicalInstruments;
          }
          break;
        case 'Scooters':
          scooters += 1;
          if (scooters > recommendValue) {
            recommendSubcategory = 'Scooters';
            recommendValue = scooters;
          }
          break;
        case 'Sofa & Dining':
          sofaAndDining += 1;
          if (sofaAndDining > recommendValue) {
            recommendSubcategory = 'Sofa & Dining';
            recommendValue = sofaAndDining;
          }
          break;
        case 'Sports Equipment':
          sportsEquipment += 1;
          if (sportsEquipment > recommendValue) {
            recommendSubcategory = 'Sports Equipment';
            recommendValue = sportsEquipment;
          }
          break;
        case 'TVs':
          tvs += 1;
          if (tvs > recommendValue) {
            recommendSubcategory = 'TVs';
            recommendValue = tvs;
          }
          break;
        case 'Women':
          women += 1;
          if (women > recommendValue) {
            recommendSubcategory = 'Women';
            recommendValue = women;
          }
          break;
        default:
          break;
      }

      // Update the modified 'recommend_analysis' map back to the 'users' document
      await userDocRef.update({
        'recommend_analysis': {
          'Accessories': accessories,
          'Beds & Wardrobes': bedsAndWardrobes,
          'Bicycles': bicycles,
          'Books': books,
          'Cameras & Lenses': camerasAndLenses,
          'Computers & Laptops': computersAndLaptops,
          'For Rent: House & Apartments': forRentHouseAndApartments,
          'For Sale: House & Apartments': forSaleHouseAndApartments,
          'Fridges': fridges,
          'Games & Entertainment': gamesAndEntertainment,
          'Gym & Fitness': gymAndFitness,
          'Home Decor & Garden': homeDecorAndGarden,
          'Kids': kids,
          'Kids Furniture': kidsFurniture,
          'Kitchen Appliances': kitchenAppliances,
          'Men': men,
          'Mobile Phones': mobilePhones,
          'Motorcycles': motorcycles,
          'Musical Instruments': musicalInstruments,
          'Scooters': scooters,
          'Sofa & Dining': sofaAndDining,
          'Sports Equipment': sportsEquipment,
          'TVs': tvs,
          'Women': women,
          'recommend_subcategory': recommendSubcategory,
          'recommend_value': recommendValue,
        },
      });

      //print('Recommendation updated successfully.');
    } else {
      print('User document not found or data is missing.');
    }
  } catch (e) {
    print('Error updating recommendation: $e');
  }
}
