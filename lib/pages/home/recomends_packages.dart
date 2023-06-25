import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:insure_boost/pages/detail_pages/package_detail_page.dart';

// import '../../../constants.dart';

class RecomendsPackages extends StatelessWidget {
  late Stream<QuerySnapshot> packages;

  @override
  Widget build(BuildContext context) {
    packages = FirebaseFirestore.instance.collection("package").snapshots();
    return StreamBuilder(
        stream: packages,
        builder: (
          BuildContext context,
          AsyncSnapshot<QuerySnapshot> snapshot,
        ) {
          if (!snapshot.hasData) {
            return Text('Something nodata ');
          } else if (snapshot.hasError) {
            return Text('Something error ');
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Text('Something noconn ');
          } else {
            final data = snapshot.requireData;
            return SizedBox(
              height: 210,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: data.size,
                itemBuilder: (context, index) {
                  return RecomendsPackagesCard(
                    image: "image/picn.png",
                    code: data.docs[index]['code'],
                    category: data.docs[index]['category'],
                    price: data.docs[index]['price'],
                    press: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PackageDetailPage(
                            id: data.docs[index].reference.id,
                            category: data.docs[index]['category'],
                            code: data.docs[index]['code'],
                            detail: data.docs[index]['detail'],
                            point: data.docs[index]['point'],
                            price: data.docs[index]['price'],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            );
          }
        });
  }
}

class RecomendsPackagesCard extends StatelessWidget {
  const RecomendsPackagesCard({
    Key? key,
    required this.image,
    required this.code,
    required this.category,
    required this.price,
    required this.press,
  }) : super(key: key);

  final String image, code, category;
  final int price;
  final Function press;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => press(),
      child: Container(
        margin: EdgeInsets.only(
          left: 20,
          top: 20 / 2,
          bottom: 20 * 2.5,
        ),
        width: size.width * 0.4,
        child: Column(
          children: <Widget>[
            Container(
              height: 100,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(image),
                  fit: BoxFit.fill,
                ),
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
            ),
            // Image.asset(image),
            Container(
              padding: EdgeInsets.all(20 / 2),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, 10),
                    blurRadius: 50,
                    color: Color(0xFF0C9869).withOpacity(0.23),
                  ),
                ],
              ),
              child: Row(
                children: <Widget>[
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                            text: "$code\n".toUpperCase(),
                            style: Theme.of(context).textTheme.button),
                        TextSpan(
                          text: "$category".toUpperCase(),
                          style: TextStyle(
                            color: Color(0xFF0C9869).withOpacity(0.5),
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  Text(
                    '\￥$price',
                    style: Theme.of(context)
                        .textTheme
                        .button
                        ?.copyWith(color: Color(0xFF0C9869)),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
