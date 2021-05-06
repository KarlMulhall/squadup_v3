import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:squadup_v3/helpers/image_helper.dart';
import 'package:squadup_v3/screens/create_post/cubit/create_post_cubit.dart';
import 'package:squadup_v3/widgets/error_dialog.dart';
import 'package:image_cropper/image_cropper.dart';

class CreatePostScreen extends StatelessWidget {
  static const String routeName = '/createPost';

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Create Post'),
        ),
        body: BlocConsumer<CreatePostCubit, CreatePostState>(
          listener: (context, state) {
            if (state.status == CreatePostStatus.success) {
              _formKey.currentState.reset();
              context.read<CreatePostCubit>().reset();

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Post Created'),
                  backgroundColor: Colors.green,
                  duration: const Duration(seconds: 1),
                ),
              );
            } else if (state.status == CreatePostStatus.error) {
              showDialog(
                context: context,
                builder: (context) =>
                    ErrorDialog(content: state.failure.message),
              );
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () => _selectPostImage(context),
                    child: Container(
                      height: MediaQuery.of(context).size.height / 2,
                      width: double.infinity,
                      color: Colors.grey[200],
                      child: state.postImage != null
                          ? Image.file(
                              state.postImage,
                              fit: BoxFit.cover,
                            )
                          : const Icon(
                              Icons.image,
                              color: Color(0xFF7986CB),
                              size: 120.0,
                            ),
                    ),
                  ),
                  if (state.status == CreatePostStatus.submitting)
                    const LinearProgressIndicator(),
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          TextFormField(
                            decoration: InputDecoration(
                              hintText: 'Add a caption...',
                              filled: true,
                              fillColor: Colors.grey[300],
                            ),
                            style: TextStyle(
                              color: Colors.indigo[400],
                              decorationColor: Colors.indigo[400],
                            ),
                            onChanged: (value) => context
                                .read<CreatePostCubit>()
                                .captionChanged(value),
                            validator: (value) => value.trim().isEmpty
                                ? 'Caption cannot be empty'
                                : null,
                          ),
                          const SizedBox(height: 28.0),
                          RaisedButton(
                            onPressed: () => _submitForm(
                              context,
                              state.postImage,
                              state.status == CreatePostStatus.submitting,
                            ),
                            elevation: 1.0,
                            color: Theme.of(context).primaryColor,
                            textColor: Colors.white,
                            child: const Text('Post'),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _selectPostImage(BuildContext context) async {
    final pickedFile = await ImageHelper.pickImageFromGallery(
      context: context,
      cropStyle: CropStyle.rectangle,
      title: 'Create Post',
    );
    if (pickedFile != null) {
      context.read<CreatePostCubit>().postImageChanged(pickedFile);
    }
  }

  void _submitForm(BuildContext context, File postImage, bool isSubmitting) {
    if (_formKey.currentState.validate() &&
        postImage != null &&
        !isSubmitting) {
      context.read<CreatePostCubit>().submit();
    }
  }
}
