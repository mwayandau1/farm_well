import 'package:flutter/material.dart';

class Cure extends StatelessWidget {
  final String diseaseName;
  const Cure(this.diseaseName, {super.key});

  static final Map<String, String> disease = {
    "Orange___Haunglongbing___(Citrus_greening)":
        "1. Apply bactericides: Use topical treatments like streptomycin or oxytetracycline to slow the bacteria causing citrus greening. Apply every 2-3 months.\n\n"
            "2. Nutrient management: Provide balanced fertilization, especially micronutrients like zinc, manganese, and boron.\n\n"
            "3. Pruning: Remove infected branches and leaves to reduce disease spread.\n\n"
            "4. Vector control: Use insecticides to control the Asian citrus psyllid, which spreads the disease.\n\n"
            "5. Thermotherapy: Apply heat treatments to infected trees (hot water treatment for seedlings or encasing mature trees with plastic and steam).\n\n"
            "Note: While these treatments can help manage the disease, there is currently no cure for citrus greening. Prevention and early detection are crucial.",
    "Pepper___bell___Bacterial___spot":
        "1. Copper treatments: Spray every 7-10 days with fixed copper (organic fungicide) to slow down the spread of infection.\n\n"
            "2. Crop rotation: Rotate peppers to a different location if infections are severe. Wait at least 1-2 years before planting peppers or related crops in the same area.\n\n"
            "3. Mulching: Cover the soil with black plastic mulch or black landscape fabric prior to planting to reduce soil splashing.\n\n"
            "4. Sanitation: Remove and destroy infected plant debris. Clean tools and equipment regularly.\n\n"
            "5. Resistant varieties: Plant pepper varieties that are resistant to bacterial spot when available.\n\n"
            "6. Improve air circulation: Proper spacing and pruning can help reduce humidity and disease spread.\n\n"
            "7. Avoid overhead irrigation: Water at the base of plants to keep foliage dry.",
    "Pepper___bell___healthy":
        "Your plant is healthy. Continue with good gardening practices:\n\n"
            "1. Regular watering: Keep soil consistently moist but not waterlogged.\n\n"
            "2. Proper fertilization: Feed with a balanced fertilizer every 4-6 weeks.\n\n"
            "3. Sunlight: Ensure plants receive 6-8 hours of full sun daily.\n\n"
            "4. Pruning: Remove any yellowing or damaged leaves to maintain plant health.\n\n"
            "5. Monitoring: Regularly check for signs of pests or diseases.",
    "Potato___Early___blight": "1. Fungicide application: Apply protectant fungicides like chlorothalonil or copper-based products every 7-10 days.\n\n"
        "2. Crop rotation: Avoid planting potatoes or related crops in the same field for at least 2 years.\n\n"
        "3. Sanitation: Remove and destroy infected plant debris after harvest.\n\n"
        "4. Proper irrigation: Use drip irrigation or water at the base of plants to keep foliage dry.\n\n"
        "5. Mulching: Apply organic mulch to prevent soil splashing onto lower leaves.\n\n"
        "6. Resistant varieties: Plant potato varieties with some resistance to early blight.\n\n"
        "7. Proper spacing: Ensure adequate spacing between plants for good air circulation.\n\n"
        "8. Harvest timing: Harvest tubers when they are fully mature to prevent damage and potential infection sites.",
    "Potato___Late___blight": "1. Fungicide application: Apply preventive fungicides like chlorothalonil or copper-based products every 5-7 days. In severe cases, use systemic fungicides like mefenoxam or cymoxanil.\n\n"
        "2. Plant removal: Remove and destroy infected plants immediately to prevent spore spread.\n\n"
        "3. Crop rotation: Avoid planting potatoes or tomatoes in the same field for at least 3 years.\n\n"
        "4. Resistant varieties: Plant potato varieties with resistance to late blight when available.\n\n"
        "5. Proper irrigation: Water early in the day and avoid overhead irrigation to keep foliage dry.\n\n"
        "6. Hilling: Increase soil hilling around plants to protect tubers from spores.\n\n"
        "7. Harvest timing: Harvest tubers after vine death and during dry weather to reduce infection risk.\n\n"
        "8. Storage: Ensure proper ventilation and temperature control in storage to prevent post-harvest infections.",
    "Potato___healthy": "Your potato plant is healthy. Maintain good practices:\n\n"
        "1. Regular watering: Keep soil consistently moist but not waterlogged.\n\n"
        "2. Proper fertilization: Apply balanced fertilizer according to soil test recommendations.\n\n"
        "3. Hilling: Continue to hill soil around plants as they grow to protect tubers.\n\n"
        "4. Monitoring: Regularly inspect plants for signs of pests or diseases.\n\n"
        "5. Crop rotation: Plan for crop rotation in the next growing season.\n\n"
        "6. Weed control: Keep the area around plants free from weeds.",
    "Tomato___Bacterial___spot": "1. Remove infected plants: Carefully remove symptomatic plants from the field or greenhouse to prevent spread.\n\n"
        "2. Copper sprays: Apply copper-based bactericides every 7-10 days, especially during wet weather.\n\n"
        "3. Crop rotation: Avoid planting tomatoes or related crops in the same area for at least 2 years.\n\n"
        "4. Sanitation: Clean and disinfect tools, stakes, and equipment regularly.\n\n"
        "5. Resistant varieties: Plant tomato varieties with resistance to bacterial spot when available.\n\n"
        "6. Proper irrigation: Use drip irrigation or water at the base of plants to keep foliage dry.\n\n"
        "7. Mulching: Apply organic mulch to reduce soil splashing onto leaves.\n\n"
        "8. Avoid handling: Don't work with plants when they're wet to prevent spread.",
    "Tomato___Early___blight": "1. Fungicide application: Treat with copper spray or biofungicides like Serenade. Apply weekly and after each rain.\n\n"
        "2. Pruning: Remove lower leaves and suckers to improve air circulation.\n\n"
        "3. Mulching: Apply organic mulch to prevent soil-borne spores from splashing onto leaves.\n\n"
        "4. Crop rotation: Avoid planting tomatoes or related crops in the same area for at least 2 years.\n\n"
        "5. Resistant varieties: Choose tomato varieties with some resistance to early blight.\n\n"
        "6. Proper spacing: Ensure adequate spacing between plants for good air circulation.\n\n"
        "7. Sanitation: Remove and destroy infected plant debris after harvest.\n\n"
        "8. Proper irrigation: Water at the base of plants and avoid overhead watering.",
    "Tomato___Late___blight": "1. Remove infected parts: Cut off all affected leaves and stems, burning them or disposing in sealed bags.\n\n"
        "2. Fungicide application: Apply fungicides containing mandipropamid, chlorothalonil, or copper oxychloride.\n\n"
        "3. Mulching: Apply straw or wood chip mulch around the base of plants to prevent spores splashing from the soil.\n\n"
        "4. Improve air circulation: Stake plants and prune to enhance airflow.\n\n"
        "5. Resistant varieties: Plant late blight-resistant tomato varieties in future seasons.\n\n"
        "6. Proper watering: Water at the base of plants and avoid overhead irrigation.\n\n"
        "7. Sanitation: Clean up all plant debris at the end of the season.\n\n"
        "8. Crop rotation: Don't plant tomatoes or potatoes in the same spot for at least 3 years.",
    "Tomato___Leaf___Mold": "1. Improve air circulation: Increase row and plant spacing to reduce humidity in the canopy.\n\n"
        "2. Prune and stake: Remove lower leaves and stake plants to improve air flow.\n\n"
        "3. Fungicide application: Apply copper-based fungicides or chlorothalonil at first sign of disease.\n\n"
        "4. Proper fertilization: Avoid excessive nitrogen, which can enhance foliage disease development.\n\n"
        "5. Temperature and humidity control: In greenhouses, maintain temperature above 65°F and relative humidity below 85%.\n\n"
        "6. Resistant varieties: Plant tomato varieties with resistance to leaf mold when available.\n\n"
        "7. Sanitation: Remove and destroy infected plant debris.\n\n"
        "8. Proper irrigation: Water at the base of plants and avoid overhead watering.",
    "Tomato___Septoria___leaf___spot":
        "1. Fungicide application: Apply sulfur sprays or copper-based fungicides weekly at first sign of disease.\n\n"
            "2. Remove infected leaves: Prune off infected lower leaves to prevent spread.\n\n"
            "3. Mulching: Apply organic mulch to prevent soil-borne spores from splashing onto leaves.\n\n"
            "4. Crop rotation: Avoid planting tomatoes or related crops in the same area for at least 2 years.\n\n"
            "5. Proper spacing: Ensure adequate spacing between plants for good air circulation.\n\n"
            "6. Sanitation: Remove and destroy infected plant debris after harvest.\n\n"
            "7. Resistant varieties: Choose tomato varieties with some resistance to Septoria leaf spot.\n\n"
            "8. Proper irrigation: Water at the base of plants and avoid overhead watering.",
    "Tomato___Spider___mites___Two-spotted___spider___mite":
        "1. Alcohol spray: Mix one part rubbing alcohol with one part water and spray on leaves.\n\n"
            "2. Soap spray: Use a solution of liquid dish soap and water to spray on plants.\n\n"
            "3. Neem oil: Apply neem oil as a natural miticide.\n\n"
            "4. Beneficial insects: Introduce natural predators like ladybugs or predatory mites.\n\n"
            "5. Proper irrigation: Regularly mist plants to increase humidity, which discourages mites.\n\n"
            "6. Prune and isolate: Remove heavily infested leaves and isolate affected plants.\n\n"
            "7. Sanitation: Clean up plant debris and weeds that may harbor mites.\n\n"
            "8. Monitor and repeat: Check plants regularly and repeat treatments as necessary.",
    "Tomato___Target___Spot":
        "1. Improve air circulation: Ensure plants aren't crowded and each has plenty of space.\n\n"
            "2. Sunlight exposure: Grow plants in full sunlight.\n\n"
            "3. Staking: Cage or stake tomato plants to keep them above the soil.\n\n"
            "4. Mulching: Apply organic mulch to prevent soil splashing.\n\n"
            "5. Fungicide application: Use fungicides containing chlorothalonil or copper compounds.\n\n"
            "6. Pruning: Remove lower leaves to improve air circulation.\n\n"
            "7. Sanitation: Remove and destroy infected plant debris.\n\n"
            "8. Crop rotation: Avoid planting tomatoes in the same spot for at least 2 years.",
    "Tomato___Tomato___Yellow___Leaf___Curl___Virus":
        "1. Remove infected plants: Uproot and destroy infected plants to prevent spread.\n\n"
            "2. Insecticide use: Apply appropriate insecticides to control whiteflies, which spread the virus.\n\n"
            "3. Resistant varieties: Plant tomato varieties resistant to TYLCV.\n\n"
            "4. Physical barriers: Use reflective mulches or row covers to deter whiteflies.\n\n"
            "5. Trap crops: Plant preferred whitefly hosts nearby to draw them away from tomatoes.\n\n"
            "6. Sanitation: Remove weeds and volunteer tomato plants that may harbor the virus.\n\n"
            "7. Timing: In affected areas, avoid planting during peak whitefly season.\n\n"
            "8. Greenhouse growing: Consider growing tomatoes under greenhouse conditions for better control.",
    "Tomato___Tomato___mosaic___virus":
        "1. Seed treatment: Treat seeds with 10% Trisodium Phosphate for at least 15 minutes.\n\n"
            "2. Resistant varieties: Plant virus-resistant tomato varieties.\n\n"
            "3. Remove infected plants: Promptly remove and destroy symptomatic plants.\n\n"
            "4. Sanitation: Thoroughly clean tools, hands, and clothing after handling infected plants.\n\n"
            "5. Weed control: Remove weeds that may serve as virus reservoirs.\n\n"
            "6. Avoid tobacco: Don't use tobacco products when working with plants, as the virus can spread from tobacco.\n\n"
            "7. Crop rotation: Practice crop rotation with non-susceptible plants.\n\n"
            "8. Aphid control: Manage aphid populations, as they can spread the virus.",
    "Tomato___healthy": "Your tomato plant is healthy. Maintain good practices:\n\n"
        "1. Regular watering: Keep soil consistently moist but not waterlogged.\n\n"
        "2. Proper fertilization: Feed with a balanced fertilizer every 4-6 weeks.\n\n"
        "3. Pruning: Remove suckers and lower leaves to improve air circulation.\n\n"
        "4. Staking: Support plants with stakes or cages.\n\n"
        "5. Mulching: Apply organic mulch around plants.\n\n"
        "6. Monitoring: Regularly check for signs of pests or diseases.\n\n"
        "7. Sunlight: Ensure plants receive 6-8 hours of full sun daily.\n\n"
        "8. Crop rotation: Plan for rotating crops in the next growing season.",
    "cashew___anthracnose": "1. Pruning: Remove and destroy affected leaves, twigs, and branches to reduce inoculum.\n\n"
        "2. Fungicide application: Apply copper-based fungicides or azoxystrobin at 10-14 day intervals.\n\n"
        "3. Timing: Start treatments at the first sign of disease or as a preventive measure before the rainy season.\n\n"
        "4. Sanitation: Clean up and destroy fallen leaves and fruit to reduce disease spread.\n\n"
        "5. Improve air circulation: Proper pruning and spacing of trees to enhance airflow.\n\n"
        "6. Water management: Avoid overhead irrigation; water at the base of trees.\n\n"
        "7. Resistant varieties: Plant cashew varieties with some resistance to anthracnose when available.\n\n"
        "8. Nutrition: Maintain proper tree nutrition to increase disease resistance.",
    "cashew___gummosis": "1. Improve drainage: Ensure proper soil drainage to prevent water logging.\n\n"
        "2. Fungicide treatment: Apply appropriate fungicides such as Metalaxyl + Mancozeb or Fosetyl-Al.\n\n"
        "3. Pruning: Remove and destroy affected plant parts, ensuring clean cuts.\n\n"
        "4. Wound dressing: Apply copper oxychloride paste to the pruned areas.\n\n"
        "5. Soil treatment: Apply Trichoderma viride to the soil to suppress soil-borne pathogens.\n\n"
        "6. Avoid injuries: Prevent mechanical injuries to the trunk and branches.\n\n"
        "7. Proper irrigation: Avoid over-watering and maintain proper irrigation schedules.\n\n"
        "8. Nutrition: Ensure balanced fertilization to improve tree vigor and resistance.",
    "cashew___healthy": "Your cashew tree is healthy. Maintain good practices:\n\n"
        "1. Regular pruning: Prune to maintain tree shape and remove dead or diseased branches.\n\n"
        "2. Irrigation: Provide adequate water, especially during flowering and fruit development.\n\n"
        "3. Fertilization: Apply balanced fertilizers based on soil test recommendations.\n\n"
        "4. Pest monitoring: Regularly check for signs of pests or diseases.\n\n"
        "5. Weed control: Keep the area around trees free from weeds.\n\n"
        "6. Mulching: Apply organic mulch around the base of trees.\n\n"
        "7. Harvesting: Harvest nuts promptly when mature.\n\n"
        "8. Sanitation: Remove fallen leaves and nuts to prevent pest and disease buildup.",
    "cashew___leaf___miner": "1. Prune affected parts: Remove and destroy heavily infested leaves.\n\n"
        "2. Insecticide application: Apply systemic insecticides like Imidacloprid or Thiamethoxam.\n\n"
        "3. Timing: Apply treatments when mines are still small and larvae are active.\n\n"
        "4. Biological control: Encourage natural predators like parasitic wasps.\n\n"
        "5. Pheromone traps: Use pheromone traps to monitor and reduce adult populations.\n\n"
        "6. Neem oil spray: Apply neem oil as a natural insecticide.\n\n"
        "7. Proper nutrition: Ensure trees are well-fertilized to improve resistance.\n\n"
        "8. Monitoring: Regularly inspect trees for early signs of infestation.",
    "cashew___red___rust": "1. Fungicide application: Apply appropriate fungicides like Hexaconazole or Propiconazole.\n\n"
        "2. Pruning: Remove and destroy severely affected leaves and twigs.\n\n"
        "3. Timing: Start treatments at the first sign of disease, typically before or during the rainy season.\n\n"
        "4. Improve air circulation: Proper pruning and spacing of trees to reduce humidity.\n\n"
        "5. Sanitation: Clean up and destroy fallen leaves to reduce inoculum.\n\n"
        "6. Nutrition: Maintain balanced tree nutrition to improve disease resistance.\n\n"
        "7. Water management: Avoid overhead irrigation; water at the base of trees.\n\n"
        "8. Monitoring: Regular scouting for early detection and treatment.",
    "cassava___bacterial___blight": "1. Use clean planting material: Plant disease-free stem cuttings.\n\n"
        "2. Resistant varieties: Plant cassava varieties resistant to bacterial blight.\n\n"
        "3. Crop rotation: Rotate cassava with non-host crops for at least one year.\n\n"
        "4. Sanitation: Remove and destroy infected plants and plant debris.\n\n"
        "5. Copper treatments: Apply copper-based bactericides as a preventive measure.\n\n"
        "6. Proper spacing: Ensure adequate plant spacing for good air circulation.\n\n"
        "7. Weed control: Keep fields free of weeds that may harbor the bacteria.\n\n"
        "8. Tool sterilization: Disinfect tools between cuts and between fields.",
    "cassava___brown___spot":
        "1. Fungicide application: Apply appropriate fungicides like Mancozeb or Copper oxychloride.\n\n"
            "2. Pruning: Remove and destroy affected leaves and stems.\n\n"
            "3. Improve air circulation: Ensure proper plant spacing and field layout.\n\n"
            "4. Resistant varieties: Plant cassava varieties with resistance to brown spot.\n\n"
            "5. Crop rotation: Rotate cassava with non-host crops.\n\n"
            "6. Sanitation: Clean up and destroy crop residues after harvest.\n\n"
            "7. Proper irrigation: Avoid overhead irrigation; water at the base of plants.\n\n"
            "8. Soil management: Maintain soil fertility and pH at optimal levels.",
    "cassava___green___mite":
        "1. Acaricide application: Use appropriate miticides like Abamectin or Spiromesifen.\n\n"
            "2. Biological control: Introduce predatory mites or other natural enemies.\n\n"
            "3. Resistant varieties: Plant cassava varieties resistant to green mites.\n\n"
            "4. Proper irrigation: Regular watering to reduce plant stress and mite population buildup.\n\n"
            "5. Intercropping: Practice intercropping to reduce mite spread and increase predator populations.\n\n"
            "6. Pruning: Remove heavily infested leaves and destroy them.\n\n"
            "7. Neem oil spray: Apply neem oil as a natural miticide.\n\n"
            "8. Monitoring: Regular scouting for early detection and treatment.",
    "cassava___healthy": "Your cassava plant is healthy. Maintain good practices:\n\n"
        "1. Proper watering: Provide adequate water, especially during dry periods.\n\n"
        "2. Fertilization: Apply balanced fertilizers based on soil test recommendations.\n\n"
        "3. Weed control: Keep the area around plants free from weeds.\n\n"
        "4. Pest monitoring: Regularly check for signs of pests or diseases.\n\n"
        "5. Pruning: Remove any yellowing or damaged leaves to maintain plant health.\n\n"
        "6. Soil management: Maintain good soil structure and fertility.\n\n"
        "7. Crop rotation: Plan for rotating crops in the next growing season.\n\n"
        "8. Harvesting: Harvest roots at the appropriate time for best quality.",
    "cassava___mosaic": "1. Use virus-free planting material: Plant only disease-free stem cuttings.\n\n"
        "2. Resistant varieties: Plant cassava varieties resistant to mosaic virus.\n\n"
        "3. Vector control: Manage whitefly populations using appropriate insecticides.\n\n"
        "4. Roguing: Remove and destroy infected plants as soon as symptoms appear.\n\n"
        "5. Weed management: Control weeds that may serve as alternative hosts for the virus.\n\n"
        "6. Intercropping: Practice intercropping to reduce vector populations.\n\n"
        "7. Quarantine: Avoid moving planting materials from infected to clean areas.\n\n"
        "8. Monitoring: Regular field inspections for early detection and removal of infected plants.",
    "maize___grasshopper": "1. Insecticide application: Use appropriate insecticides like Carbaryl or Malathion.\n\n"
        "2. Timing: Apply treatments early in the morning or late in the evening when grasshoppers are less active.\n\n"
        "3. Biological control: Introduce natural predators like birds or parasitic wasps.\n\n"
        "4. Trap crops: Plant attractive crops around field borders to lure grasshoppers away from main crop.\n\n"
        "5. Mechanical control: Use grasshopper catchers or vacuum devices in small areas.\n\n"
        "6. Crop rotation: Rotate maize with non-host crops to disrupt grasshopper life cycles.\n\n"
        "7. Field sanitation: Remove crop residues and control weeds to reduce egg-laying sites.\n\n"
        "8. Monitoring: Regular scouting for early detection and treatment.",
    "maize___healthy": "Your maize plant is healthy. Maintain good practices:\n\n"
        "1. Proper irrigation: Provide adequate water, especially during critical growth stages.\n\n"
        "2. Fertilization: Apply balanced fertilizers based on soil test recommendations.\n\n"
        "3. Weed control: Keep the field free from weeds that compete for nutrients.\n\n"
        "4. Pest monitoring: Regularly check for signs of pests or diseases.\n\n"
        "5. Soil management: Maintain good soil structure and fertility.\n\n"
        "6. Crop rotation: Plan for rotating crops in the next growing season.\n\n"
        "7. Proper spacing: Ensure adequate plant spacing for optimal growth.\n\n"
        "8. Timely harvesting: Harvest at the right time to prevent losses.",
    "maize___leaf___beetle": "1. Insecticide application: Use appropriate insecticides like Carbaryl or Permethrin.\n\n"
        "2. Timing: Apply treatments when beetles or larvae are first noticed.\n\n"
        "3. Biological control: Encourage natural predators like ladybugs and lacewings.\n\n"
        "4. Crop rotation: Rotate maize with non-host crops to disrupt beetle life cycles.\n\n"
        "5. Trap crops: Plant attractive crops nearby to lure beetles away from main crop.\n\n"
        "6. Mechanical control: Hand-pick beetles in small plots.\n\n"
        "7. Sanitation: Remove crop residues after harvest to reduce overwintering sites.\n\n"
        "8. Resistant varieties: Plant maize varieties with some resistance to leaf beetles when available.",
    "maize___leaf___blight": "1. Fungicide application: Apply appropriate fungicides like Azoxystrobin or Pyraclostrobin.\n\n"
        "2. Timing: Start treatments at the first sign of disease, especially in humid conditions.\n\n"
        "3. Resistant varieties: Plant maize varieties with resistance to leaf blight.\n\n"
        "4. Crop rotation: Rotate maize with non-host crops for at least one year.\n\n"
        "5. Residue management: Practice deep plowing or remove crop residues to reduce inoculum.\n\n"
        "6. Proper spacing: Ensure adequate plant spacing for good air circulation.\n\n"
        "7. Balanced fertilization: Avoid excessive nitrogen application.\n\n"
        "8. Irrigation management: Avoid overhead irrigation; water at the base of plants.",
    "maize___streak___virus": "1. Vector control: Manage leafhopper populations using appropriate insecticides.\n\n"
        "2. Resistant varieties: Plant maize varieties resistant to maize streak virus.\n\n"
        "3. Early planting: Plant early to avoid peak leafhopper populations.\n\n"
        "4. Roguing: Remove and destroy infected plants as soon as symptoms appear.\n\n"
        "5. Weed management: Control grassy weeds that may serve as alternative hosts.\n\n"
        "6. Crop rotation: Rotate maize with non-host crops to reduce virus reservoirs.\n\n"
        "7. Fallow periods: Implement fallow periods to break the disease cycle.\n\n"
        "8. Monitoring: Regular field inspections for early detection and removal of infected plants.",
    "rice___bacterial___leaf___blight":
        "1. Resistant varieties: Plant rice varieties with resistance to bacterial leaf blight.\n\n"
            "2. Seed treatment: Treat seeds with hot water (52°C for 30 minutes) before planting.\n\n"
            "3. Copper treatments: Apply copper-based bactericides as a preventive measure.\n\n"
            "4. Water management: Avoid excessive flooding and maintain proper drainage.\n\n"
            "5. Balanced fertilization: Avoid excessive nitrogen application.\n\n"
            "6. Sanitation: Remove and destroy infected plant debris.\n\n"
            "7. Crop rotation: Rotate rice with non-host crops.\n\n"
            "8. Weed control: Manage weeds that may serve as alternative hosts.",
    "rice___brown___spot":
        "1. Fungicide application: Apply appropriate fungicides like Propiconazole or Carbendazim.\n\n"
            "2. Seed treatment: Treat seeds with fungicides before planting.\n\n"
            "3. Balanced fertilization: Ensure adequate potassium and avoid excessive nitrogen.\n\n"
            "4. Water management: Maintain proper water levels and avoid water stress.\n\n"
            "5. Resistant varieties: Plant rice varieties with some resistance to brown spot.\n\n"
            "6. Sanitation: Remove and destroy infected plant debris.\n\n"
            "7. Crop rotation: Rotate rice with non-host crops.\n\n"
            "8. Timing: Apply treatments at the first sign of disease, especially during tillering and flowering stages.",
    "rice___healthy": "Your rice plant is healthy. Maintain good practices:\n\n"
        "1. Water management: Maintain proper water levels throughout the growing season.\n\n"
        "2. Fertilization: Apply balanced fertilizers based on soil test recommendations.\n\n"
        "3. Weed control: Keep the field free from weeds that compete for nutrients.\n\n"
        "4. Pest monitoring: Regularly check for signs of pests or diseases.\n\n"
        "5. Proper spacing: Ensure adequate plant spacing for optimal growth.\n\n"
        "6. Soil management: Maintain good soil structure and fertility.\n\n"
        "7. Timely harvesting: Harvest at the right time to prevent losses.\n\n"
        "8. Post-harvest handling: Properly dry and store harvested rice to maintain quality.",
    "rice___leaf___blast": "1. Fungicide application: Apply systemic fungicides like Tricyclazole or Azoxystrobin.\n\n"
        "2. Resistant varieties: Plant rice varieties with resistance to leaf blast.\n\n"
        "3. Nitrogen management: Avoid excessive nitrogen fertilization.\n\n"
        "4. Water management: Maintain consistent water levels to reduce plant stress.\n\n"
        "5. Timing: Apply treatments preventively or at the first sign of disease.\n\n"
        "6. Silica application: Apply silica to strengthen plant cell walls.\n\n"
        "7. Sanitation: Remove and destroy infected plant debris.\n\n"
        "8. Crop rotation: Rotate rice with non-host crops to reduce inoculum buildup.",
    "rice___leaf___scald": "1. Fungicide application: Apply appropriate fungicides like Propiconazole or Tebuconazole.\n\n"
        "2. Resistant varieties: Plant rice varieties with resistance to leaf scald.\n\n"
        "3. Water management: Avoid water stress and maintain proper irrigation.\n\n"
        "4. Balanced fertilization: Ensure proper nutrient balance, especially potassium.\n\n"
        "5. Sanitation: Remove and destroy infected plant debris.\n\n"
        "6. Crop rotation: Rotate rice with non-host crops.\n\n"
        "7. Seed treatment: Use clean, disease-free seeds or treat seeds with fungicides.\n\n"
        "8. Timing: Apply treatments at the first sign of disease, especially during the reproductive stage.",
    "rice___narrow___brown___spot":
        "1. Fungicide application: Apply appropriate fungicides like Propiconazole or Azoxystrobin.\n\n"
            "2. Resistant varieties: Plant rice varieties with resistance to narrow brown spot.\n\n"
            "3. Balanced fertilization: Ensure adequate potassium and avoid excessive nitrogen.\n\n"
            "4. Water management: Maintain proper water levels and avoid water stress.\n\n"
            "5. Sanitation: Remove and destroy infected plant debris.\n\n"
            "6. Crop rotation: Rotate rice with non-host crops.\n\n"
            "7. Seed treatment: Use clean, disease-free seeds or treat seeds with fungicides.\n\n"
            "8. Timing: Apply treatments at the first sign of disease, especially during the reproductive stage.",
    "soybean___caterpillar": "1. Insecticide application: Use appropriate insecticides like Bacillus thuringiensis (Bt) or Spinosad.\n\n"
        "2. Timing: Apply treatments when caterpillars are small and damage is first noticed.\n\n"
        "3. Biological control: Encourage natural predators like parasitic wasps.\n\n"
        "4. Pheromone traps: Use pheromone traps to monitor and reduce adult moth populations.\n\n"
        "5. Crop rotation: Rotate soybeans with non-host crops to disrupt caterpillar life cycles.\n\n"
        "6. Resistant varieties: Plant soybean varieties with some resistance to caterpillar pests.\n\n"
        "7. Scouting: Regularly inspect plants for eggs and young caterpillars.\n\n"
        "8. Cultural control: Adjust planting dates to avoid peak caterpillar seasons.",
    "soybean___diabrotica_speciosa":
        "1. Insecticide application: Use appropriate insecticides like Imidacloprid or Thiamethoxam.\n\n"
            "2. Seed treatment: Treat seeds with systemic insecticides before planting.\n\n"
            "3. Crop rotation: Rotate soybeans with non-host crops to disrupt beetle life cycles.\n\n"
            "4. Trap crops: Plant attractive crops nearby to lure beetles away from main crop.\n\n"
            "5. Timing: Apply treatments when adult beetles are first noticed.\n\n"
            "6. Biological control: Encourage natural predators and use entomopathogenic nematodes.\n\n"
            "7. Sanitation: Remove crop residues and control weeds to reduce overwintering sites.\n\n"
            "8. Monitoring: Regular scouting for early detection and treatment.",
    "soybean___healthy": "Your soybean plant is healthy. Maintain good practices:\n\n"
        "1. Proper irrigation: Provide adequate water, especially during critical growth stages.\n\n"
        "2. Fertilization: Apply balanced fertilizers based on soil test recommendations.\n\n"
        "3. Weed control: Keep the field free from weeds that compete for nutrients.\n\n"
        "4. Pest monitoring: Regularly check for signs of pests or diseases.\n\n"
        "5. Proper spacing: Ensure adequate plant spacing for optimal growth.\n\n"
        "6. Soil management: Maintain good soil structure and fertility.\n\n"
        "7. Crop rotation: Plan for rotating crops in the next growing season.\n\n"
        "8. Timely harvesting: Harvest at the right time to prevent losses and maintain quality.",
  };

  static String getDiseaseCure(String diseaseName) {
    return disease[diseaseName] ?? 'No cure available';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plant Disease Recognition'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              "Cure : ",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Text(
                disease[diseaseName] ??
                    'No cure information available for this disease.',
                style: const TextStyle(fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
