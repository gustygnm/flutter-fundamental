import 'package:bobobox_restaurant/common/constants.dart';
import 'package:bobobox_restaurant/presentation/widget/custom_button.dart';
import 'package:bobobox_restaurant/presentation/widget/custom_text_field.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bobobox_restaurant/data/remote/datasource/api_constant.dart';
import 'package:bobobox_restaurant/data/remote/datasource/remote_data_source.dart';
import 'package:bobobox_restaurant/data/remote/repository/restaurant_repository_impl.dart';
import 'package:bobobox_restaurant/domain/usecase/add_review_usecase.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bobobox_restaurant/presentation/bloc/add_review/add_review_bloc.dart';

class AddReviewScreen extends StatelessWidget {
  final String restaurantId;
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _reviewController = TextEditingController();
  final FocusNode _reviewFocusNode = FocusNode();

  AddReviewScreen({@required this.restaurantId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddReviewBloc(
          addReviewUseCase: AddReviewUseCaseImpl(
              restaurantRepository: RestaurantRepositoryIml(
                  remoteDataSource: RemoteDataSourceImpl(
                      dio: Dio(BaseOptions(baseUrl: ApiConstant.baseUrl)))))),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: cPrimary,
          iconTheme: IconThemeData(color: cWhite),
          title: Text(
            "Add Review",
            style: TextStyle(
                color: cWhite, fontWeight: FontWeight.bold, fontSize: 20.sp),
          ),
        ),
        body: BlocListener<AddReviewBloc, AddReviewState>(
          listener: (context, state) {
            if (state is AddReviewSuccessState) {
              Navigator.pop(context);
            } else if (state is AddReviewFailedState) {
              errorMessage(context, "An error occurred please try again later");
            } else if (state is AddReviewNameEmptyState) {
              errorMessage(context, "Name cannot be empty");
            } else if (state is AddReviewReviewEmptyState) {
              errorMessage(context, "Review cannot be empty");
            }
          },
          child: ListView(
            children: [
              CustomTextField(
                  controller: _userNameController,
                  hint: "Your name",
                  onFieldSubmitted: (v) =>
                      FocusScope.of(context).requestFocus(_reviewFocusNode),
                  keyboardType: TextInputType.name),
              CustomTextField(
                controller: _reviewController,
                hint: "Your review",
                keyboardType: TextInputType.multiline,
                maxLines: null,
                focusNode: _reviewFocusNode,
              ),
              Padding(
                padding: EdgeInsets.all(16.w),
                child: BlocBuilder<AddReviewBloc, AddReviewState>(
                    builder: (context, state) {
                  if (state is AddReviewLoadingState) {
                    return Stack(
                      children: [
                        CustomButton(
                          borderRadius: 10.0,
                          text: "Add Review",
                          onTap: () => {},
                        ),
                        Center(
                          child: CircularProgressIndicator(
                            valueColor:
                                new AlwaysStoppedAnimation<Color>(cDarkGrey),
                          ),
                        ),
                      ],
                    );
                  } else {
                    return CustomButton(
                      borderRadius: 10.0,
                      text: "Add Review",
                      onTap: () => BlocProvider.of<AddReviewBloc>(context).add(
                          AddReview(
                              restaurantId: restaurantId,
                              userName: _userNameController.text,
                              review: _reviewController.text)),
                    );
                  }
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void errorMessage(context, String message) {
    final _snackBar = SnackBar(
      duration: const Duration(seconds: 1),
      backgroundColor: Colors.red,
      content: Text(
        message,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16.sp,
          color: Colors.white,
        ),
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(_snackBar);
  }
}