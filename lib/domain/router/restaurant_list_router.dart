import 'package:bobobox_restaurant/presentation/pages/add_review_screen.dart';
import 'package:bobobox_restaurant/presentation/pages/detail_restaurant_screen/detail_restaurant_screen.dart';
import 'package:bobobox_restaurant/presentation/pages/search_restaurant_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bobobox_restaurant/presentation/bloc/detail_restaurant_bloc/get_detail_restaurant_bloc.dart';

abstract class RestaurantListRouter {
  goToDetailListRestaurant(context, String restaurantId, String restaurantName,
      String restaurantImage);

  goToSearchRestaurant(context);

  goToAddReview(context, String restaurantId);
}

class RestaurantListRouterImpl extends RestaurantListRouter {
  @override
  goToDetailListRestaurant(context, String restaurantId, String restaurantName,
          String restaurantImage) =>
      Navigator.push(
        context,
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 1000),
          pageBuilder: (BuildContext context, Animation<double> animation,
                  Animation<double> secondaryAnimation) =>
              DetailRestaurantScreen(
            restaurantId: restaurantId,
            restaurantImage: restaurantImage,
            restaurantName: restaurantName,
          ),
        ),
      );

  @override
  goToSearchRestaurant(context) => Navigator.push(context,
      MaterialPageRoute(builder: (context) => SearchRestaurantScreen()));

  @override
  goToAddReview(context, String restaurantId) => Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              AddReviewScreen(restaurantId: restaurantId))).then((value) =>
      BlocProvider.of<GetDetailRestaurantBloc>(context)
          .add(GetDetailRestaurant(restaurantId: restaurantId)));
}
