import 'package:cool_cooker/app_localizations.dart';
import 'package:cool_cooker/core/model/recipe/recipe.dart';
import 'package:cool_cooker/ui/provider/slider_model.dart';
import 'package:cool_cooker/utils/number_utils.dart';
import 'package:flutter/material.dart';


class RecipeIngredientsSliderScreen extends StatelessWidget {
  final Recipe recipe;
  final SliderModel model;

  RecipeIngredientsSliderScreen(this.recipe, this.model);

  @override
  Widget build(BuildContext context) {
    return recipe == null || NumberUtils.intIsBlank(recipe.nbPersons) ?
    SizedBox() : InkWell(
      child: Row(
          children: [
            Expanded(
              child: Slider(
                value: model.value,
                min: model.min,
                max: model.max,
                divisions: model.divisions,
                label: model.value.round().toString(),
                onChanged: (double value) {
                  model.onChange(value);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
              child: Text(
                  model.value.round().toString() + " " +
                      AppLocalizations.of(context).getMessage(
                          'recipe.nb_persons')
              ),
            )
          ]
      ),
      onLongPress: () {
        if (model.onReset != null) {
          model.onReset();
        }
      },
      onDoubleTap: () {
        if (model.onReset != null) {
          model.onReset();
        }
      },
    );
  }
}
