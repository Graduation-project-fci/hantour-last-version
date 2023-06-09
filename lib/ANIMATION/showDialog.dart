import 'package:flutter/material.dart';

class AnimatedErrorDialog extends StatefulWidget {
  final String errorMessage, ErrorTitle;
  final IconData icon;
  // final VoidCallback func;

  AnimatedErrorDialog({
    required this.ErrorTitle,
    required this.errorMessage,
    required this.icon,
  });

  @override
  _AnimatedErrorDialogState createState() => _AnimatedErrorDialogState();
}

class _AnimatedErrorDialogState extends State<AnimatedErrorDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );
    _scaleAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          padding: EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                widget.icon,
                color: Colors.red,
                size: 60.0,
              ),
              SizedBox(height: 20.0),
              Text(
                '${widget.ErrorTitle}',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10.0),
              Text(
                widget.errorMessage,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                child: Text('OK'),
                onPressed: () {
                  // widget.func;
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
