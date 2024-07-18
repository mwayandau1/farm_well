import 'package:flutter/material.dart';

class Cure extends StatelessWidget {
  final String diseaseName;
  const Cure(this.diseaseName, {super.key});

  static final Map<String, String> disease = {
    "Orange___Haunglongbing_(Citrus_greening)":
        "Bactericides are a topical treatment aimed at slowing the bacteria that cause citrus greening. The bactericides do not absorb into the tree or fruit. While this is a relatively new treatment for citrus trees.",
    "Pepper,_bell___Bacterial_spot":
        "Spray every 10-14 days with fixed copper (organic fungicide) to slow down the spread of infection. Rotate peppers to a different location if infections are severe and cover the soil with black plastic mulch or black landscape fabric prior to planting.",
    "Pepper,_bell___healthy": "Your plant is already healthy.",
    "Potato___Early_blight":
        "Avoid overhead irrigation. Do not dig tubers until they are fully mature in order to prevent damage. Do not use a field for potatoes that was used for potatoes or tomatoes the previous year.",
    "Potato___Late_blight":
        "Fungicides are available for management of late blight on potato.",
    "Potato___healthy": "Your plant is already healthy.",
    "Tomato___Bacterial_spot":
        "A plant with bacterial spot cannot be cured. Remove symptomatic plants from the field or greenhouse to prevent the spread of bacteria to healthy plants. Burn, bury or hot compost the affected plants and DO NOT eat symptomatic fruit.",
    "Tomato___Early_blight":
        "Treat organically with copper spray. Follow label directions. You can apply until the leaves are dripping, once a week and after each rain. Or you can treat it organically with a biofungicide like Serenade.",
    "Tomato___Late_blight":
        "Remove all affected leaves and burn them or place them in the garbage. Mulch around the base of the plant with straw, wood chips or other natural mulch to prevent fungal spores in the soil from splashing on the plant.",
    "Tomato___Leaf_Mold":
        "By adequately spacing rows and plants to promote better air circulation through the canopy, reducing humidity; preventing excessive nitrogen on fertilization since nitrogen out of balance enhances foliage disease development.",
    "Tomato___Septoria_leaf_spot":
        "Apply sulfur sprays or copper-based fungicides weekly at first sign of disease to prevent its spread. These organic fungicides will not kill leaf spot, but prevent the spores from germinating.",
    "Tomato___Spider_mites Two-spotted_spider_mite":
        "A natural way to kill spider mites on your plants is to mix one part rubbing alcohol with one part water, then spray the leaves. The alcohol will kill the mites without harming the plants. Another natural solution to get rid of these tiny pests is to use liquid dish soap.",
    "Tomato___Target_Spot":
        "Target spot tomato treatment requires a multi-pronged approach. Pay careful attention to air circulation, as target spot of tomato thrives in humid conditions. Grow the plants in full sunlight. Be sure the plants aren’t crowded and that each tomato has plenty of air circulation. Cage or stake tomato plants to keep the plants above the soil.",
    "Tomato___Tomato_Yellow_Leaf_Curl_Virus":
        "Treatment for this disease includes insecticides, hybrid seeds, and growing tomatoes under greenhouse conditions.",
    "Tomato___Tomato_mosaic_virus":
        "By treating seeds with 10% Trisodium Phosphate for at least 15 minutes. Whenever possible, virus-resistant tomatoes should be planted. Additionally, removal of symptomatic plants may slow the spread of disease once it occurs.",
    "Tomato___healthy": "Your plant is already healthy.",
    "cassava_bacterial_blight":
        "Remove and destroy infected plants. Use disease-free planting material and practice crop rotation with non-host crops. Apply copper-based bactericides as a preventative measure.",
    "cassava_brown_spot":
        "Remove and destroy affected leaves. Use resistant varieties and practice crop rotation. Apply fungicides if necessary.",
    "cassava_green_mite":
        "Use biological control agents like predatory mites. Apply miticides if infestations are severe.",
    "cassava_healthy": "Your plant is already healthy.",
    "cassava_mosaic":
        "Use disease-resistant varieties. Remove and destroy infected plants. Use virus-free planting material and practice crop rotation.",
    "maize_grasshopper":
        "Use insecticidal sprays or dusts to control grasshopper populations. Practice field sanitation to reduce grasshopper habitats.",
    "maize_healthy": "Your plant is already healthy.",
    "maize_leaf_beetle":
        "Use insecticides to control beetle populations. Practice crop rotation and field sanitation to reduce beetle habitats.",
    "maize_leaf_blight":
        "Apply fungicides early in the season to reduce disease severity. Practice crop rotation and use resistant varieties.",
    "maize_streak_virus":
        "Use resistant varieties and plant early to avoid peak periods of vector activity. Control insect vectors with insecticides.",
    "rice___bacterial_leaf_blight":
        "Use resistant varieties and avoid excessive nitrogen fertilization. Apply copper-based bactericides if necessary.",
    "rice___brown_spot":
        "Use resistant varieties and practice good field sanitation. Apply fungicides if necessary.",
    "rice___healthy": "Your plant is already healthy.",
    "rice___leaf_blast":
        "Use resistant varieties and practice good field sanitation. Apply fungicides at the early stages of the disease.",
    "rice___leaf_scald":
        "Use resistant varieties and maintain proper field sanitation. Apply fungicides if necessary.",
    "rice___narrow_brown_spot":
        "Use resistant varieties and practice good field sanitation. Apply fungicides if necessary.",
    "soybean___caterpillar":
        "Use insecticides to control caterpillar populations. Employ biological control agents like parasitic wasps.",
    "soybean___diabrotica_speciosa":
        "Use insecticides to control beetle populations. Practice crop rotation and field sanitation to reduce beetle habitats.",
    "soybean___healthy": "Your plant is already healthy."
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
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: Text(getDiseaseCure(diseaseName)),
            ),
          ],
        ),
      ),
    );
  }
}
