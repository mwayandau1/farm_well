import 'package:flutter/material.dart';

class Cure extends StatelessWidget {
  final String diseaseName;
  const Cure(this.diseaseName, {super.key});

  static final Map<String, String> disease = {
    "Orange___Haunglongbing___(Citrus_greening)":
        "Bactericides are a topical treatment aimed at slowing the bacteria that cause citrus greening. The bactericides do not absorb into the tree or fruit. While this is a relatively new treatment for citrus trees.",
    "Pepper___bell___Bacterial___spot":
        "Spray every 10-14 days with fixed copper (organic fungicide) to slow down the spread of infection. Rotate peppers to a different location if infections are severe and cover the soil with black plastic mulch or black landscape fabric prior to planting.",
    "Pepper___bell___healthy": "Your plant is already healthy",
    "Potato___Early___blight":
        "Avoid overhead irrigation. Do not dig tubers until they are fully mature in order to prevent damage. Do not use a field for potatoes that was used for potatoes or tomatoes the previous year.",
    "Potato___Late___blight":
        "Fungicides are available for management of late blight on potato.",
    "Potato___healthy": "Your plant is already healthy",
    "Tomato___Bacterial___spot":
        "A plant with bacterial spot cannot be cured. Remove symptomatic plants from the field or greenhouse to prevent the spread of bacteria to healthy plants. Burn, bury or hot compost the affected plants and DO NOT eat symptomatic fruit.",
    "Tomato___Early___blight":
        "Treat organically with copper spray. Follow label directions. You can apply until the leaves are dripping, once a week and after each rain. Or you can treat it organically with a biofungicide like Serenade.",
    "Tomato___Late___blight":
        "Remove all affected leaves and burn them or place them in the garbage. Mulch around the base of the plant with straw, wood chips or other natural mulch to prevent fungal spores in the soil from splashing on the plant.",
    "Tomato___Leaf___Mold":
        "By adequating row and plant spacing that promote better air circulation through the canopy reducing the humidity; preventing excessive nitrogen on fertilization since nitrogen out of balance enhances foliage disease development.",
    "Tomato___Septoria___leaf___spot":
        "Apply sulfur sprays or copper-based fungicides weekly at first sign of disease to prevent its spread. These organic fungicides will not kill leaf spot, but prevent the spores from germinating.",
    "Tomato___Spider___mites___Two-spotted___spider___mite":
        "A natural way to kill spider mites on your plants is to mix one part rubbing alcohol with one part water, then spray the leaves. The alcohol will kill the mites without harming the plants. Another natural solution to get rid of these tiny pests is to use liquid dish soap.",
    "Tomato___Target___Spot":
        "Target spot tomato treatment requires a multi-pronged approach. Pay careful attention to air circulation, as target spot of tomato thrives in humid conditions. Grow the plants in full sunlight. Be sure the plants aren’t crowded and that each tomato has plenty of air circulation. Cage or stake tomato plants to keep the plants above the soil.",
    "Tomato___Tomato___Yellow___Leaf___Curl___Virus":
        "Treatment for this disease include insecticides, hybrid seeds, and growing tomatoes under greenhouse conditions.",
    "Tomato___Tomato___mosaic___virus":
        "By treating seeds with 10% Trisodium Phosphate for at least 15 minutes. Whenever possible, virus resistant tomatoes should be planted. Additionally, removal of symptomatic plants may slow the spread of disease once it occurs.",
    "Tomato___healthy": "Your plant is already healthy",
    "cashew___anthracnose":
        "Prune and destroy affected leaves and branches. Apply fungicides to control the spread of the disease.",
    "cashew___gumosis":
        "Improve drainage in the soil and apply fungicides. Remove and destroy affected plant parts.",
    "cashew___healthy": "Your plant is already healthy",
    "cashew___leaf___miner":
        "Remove and destroy infested leaves. Apply insecticides if the infestation is severe.",
    "cashew___red___rust":
        "Remove and destroy affected leaves. Apply appropriate fungicides to control the disease.",
    "cassava___bacterial___blight":
        "Use disease-free planting materials. Apply copper-based bactericides to manage the disease.",
    "cassava___brown___spot":
        "Remove and destroy affected plant parts. Apply fungicides to manage the disease.",
    "cassava___green___mite":
        "Apply appropriate miticides to control the mite population.",
    "cassava___healthy": "Your plant is already healthy",
    "cassava___mosaic":
        "Use resistant varieties and virus-free planting materials. Remove and destroy affected plants.",
    "maize___grasshoper":
        "Apply appropriate insecticides to control the grasshopper population.",
    "maize___healthy": "Your plant is already healthy",
    "maize___leaf___beetle":
        "Use insecticides to manage the leaf beetle population.",
    "maize___leaf___blight":
        "Fungicide application to reduce yield loss and improve harvestability.",
    "maize___streak___virus":
        "Use resistant varieties and apply appropriate insecticides to control the vector population.",
    "rice___bacterial___leaf___blight":
        "Use resistant varieties and apply copper-based bactericides to manage the disease.",
    "rice___brown___spot":
        "Remove and destroy affected plant parts. Apply appropriate fungicides to manage the disease.",
    "rice___healthy": "Your plant is already healthy",
    "rice___leaf___blast":
        "Use resistant varieties and apply appropriate fungicides to control the disease.",
    "rice___leaf___scald":
        "Use resistant varieties and apply fungicides to manage the disease.",
    "rice___narrow___brown___spot":
        "Remove and destroy affected plant parts. Apply appropriate fungicides to manage the disease.",
    "soybean___caterpillar":
        "Apply appropriate insecticides to control the caterpillar population.",
    "soybean___diabrotica_speciosa":
        "Use insecticides to manage the Diabrotica population.",
    "soybean___healthy": "Your plant is already healthy"
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
