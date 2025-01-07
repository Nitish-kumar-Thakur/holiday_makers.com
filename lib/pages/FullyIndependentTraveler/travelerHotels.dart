import 'package:flutter/material.dart';
import 'package:holdidaymakers/pages/FullyIndependentTraveler/offersDiscount.dart';
import 'package:holdidaymakers/widgets/appLargetext.dart';
import 'package:holdidaymakers/widgets/appText.dart';
import 'package:holdidaymakers/widgets/responciveButton.dart';

class Travelerhotels extends StatefulWidget {
  const Travelerhotels({super.key});

  @override
  State<Travelerhotels> createState() => _TravelerhotelsState();
}

class _TravelerhotelsState extends State<Travelerhotels> {
  Widget buildInclusionCard(String imagePath, String label) {
    return Container(
      width: 71,
      height: 61,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 40,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(imagePath),
              ),
            ),
          ),
          const SizedBox(height: 4),
          AppText(
            text: label,
            size: 12,
            color: Colors.black,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('img/hotel1.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppLargeText(
                            text: 'Grand Inn Baku',
                            color: Colors.white,
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.location_on,
                                color: Colors.white,
                                size: 30,
                              ),
                              AppText(
                                text: 'Baku, Azerbaijan',
                                color: Colors.white,
                                size: 20,
                              )
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(color: Colors.grey.shade200),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppLargeText(
                      text: 'INCLUSION',
                      size: 25,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        buildInclusionCard('img/flight.png', 'Flights'),
                        buildInclusionCard('img/hotels.png', 'Hotels'),
                        buildInclusionCard('img/transfers.png', 'Transfers'),
                        buildInclusionCard('img/insurance.png', 'Insurance'),
                      ],
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 450,
                      child: ListView.builder(
                        itemCount: 3,
                        itemBuilder: (_, index) {
                          return Container(
                            margin: const EdgeInsets.only(bottom: 15),
                            height: 450,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: Colors.white
                            ),
                            child: Column(
                              children: [
                                Container(
                                  height: 200,
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(30),
                                      topRight: Radius.circular(30),
                                    ),
                                    image: DecorationImage(
                                      image: AssetImage('img/hotel1.png'),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 30,
                                  child: Row(
                                    children: [
                                      AppLargeText(
                                        text: 'Grand Inn Baku',
                                        size: 25,
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 40,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      AppText(text: 'Baku, Azerbaijan'),
                                      IconButton(
                                        onPressed: null,
                                        icon: AppText(
                                          text: 'READ MORE',
                                          color: Colors.red,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  width: double.infinity,
                                  height: 1,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade300,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Container(
                                  width: double.infinity,
                                  height: 55,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.blueGrey,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(5)
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      RichText(
                                        text: TextSpan(
                                          style: const TextStyle(
                                            fontSize: 20,
                                            color: Colors.black,
                                          ),
                                          children: [
                                            const TextSpan(
                                              text: 'AED 2,377',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            TextSpan(
                                              text: '/Price Per Person',
                                              style: TextStyle(
                                                color: Colors.grey.shade600,
                                                fontSize: 15,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      AppText(
                                        text: 'Total Price ₹1,43,584',
                                        size: 15,
                                      )
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 15),
                                IconButton(
                                  onPressed: () {
                                    // Navigator.push(
                                    //   context,
                                    //   MaterialPageRoute(
                                    //     builder: (context) => Offersdiscount(),
                                    //   ),
                                    // );
                                  },
                                  icon: responciveButton(text: 'SELECT'),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
