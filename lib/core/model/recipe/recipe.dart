import 'package:cool_cooker/core/model/abstract_countable_model.dart';
import 'package:cool_cooker/core/model/abstract_model.dart';
import 'package:cool_cooker/core/model/factory/api/recipe/ingredient_factory.dart';
import 'package:cool_cooker/core/model/factory/api/recipe/instruction_factory.dart';
import 'package:cool_cooker/core/model/factory/factory_locator_setup.dart';
import 'package:cool_cooker/core/model/recipe/ingredient.dart';
import 'package:cool_cooker/core/model/recipe/instruction.dart';
import 'package:cool_cooker/core/model/recipe/recipe_site_type.dart';
import 'package:cool_cooker/core/model/shopping/shopping_recipe.dart';
import 'package:cool_cooker/utils/list_utils.dart';
import 'package:cool_cooker/utils/number_utils.dart';
import 'package:cool_cooker/utils/string_utils.dart';

class Recipe extends AbstractCountableModel {
  String _url;
  RecipeSiteType _siteType;
  int _nbPersons;
  List<Ingredient> _ingredients = new List();
  List<Instruction> _instructions = new List();
  ShoppingRecipe fromShoppingRecipe;

  Recipe() : super();

  Recipe.name(String name) : super.name(name);

  Recipe.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    this.url = json['url'];
    this.siteType = StringUtils.isNotBlank(json['url']) ? RecipeSiteTypeUtils.urlToType(json['url']) : null;
    this.nbPersons = json['nb_persons'];

    if(json['ingredients'] != null) {
      this.ingredients =
          this._ingredientFactory.transformListFromJson(json['ingredients']);
    }

    if(json['instructions'] != null) {
      this.instructions =
          this._instructionFactory.transformListFromJson(json['instructions']);
    }
  }


  String get url {
    return _url;
  }
  set url(String url) {
    if(!StringUtils.isUrl(url)) {
      url = null;
    }
    this._url = url;
  }

  RecipeSiteType get siteType {
    if(_siteType == null) {
      _siteType = RecipeSiteType.NONE;
    }
    return _siteType;
  }
  set siteType(RecipeSiteType siteType) {
    this._siteType = siteType;
  }

  int get nbPersons {
    return _nbPersons;
  }
  set nbPersons(int nbPersons) {
    if(nbPersons != null && nbPersons <= 0) {
      print("nbPersons should be greater than 0");
    }  else {
      this._nbPersons = nbPersons;
    }
  }

  List<Ingredient> get ingredients {
    if(_ingredients == null) {
      _ingredients = new List();
    }
    return _ingredients;
  }
  set ingredients(List<Ingredient> ingredients) {
    this._ingredients = ingredients;
  }
  void addIngredient(Ingredient ingredient) {
    if(ingredient != null && !ingredient.isEmpty()) {
      if(containsIngredient(ingredient)) {
        ListUtils.replace(this.ingredients, ingredient);
      } else {
        this.ingredients.add(ingredient);
      }
    }
  }
  bool containsIngredient(Ingredient ingredient) {
    if(ingredient != null) {
      return this.ingredients.contains(ingredient);
    }
    return false;
  }

  List<Instruction> get instructions {
    if(_instructions == null) {
      _instructions = new List();
    }
    return _instructions;
  }
  set instructions(List<Instruction> instructions) {
    this._instructions = instructions;
    sortInstructions();
  }
  void addInstruction(Instruction instruction) {
    if(instruction != null && !instruction.isEmpty()) {
      if(instruction.order == null || instruction.order >= this.instructions.length + 1) {
        instruction.order = this.instructions.length + 1;
      }

      sortInstructions();

      for(int i = 0; i < this.instructions.length; i++) {
        this.instructions[i].order = i + (instruction.order <= i ? 2 : 1);
      }

      if(containsInstruction(instruction)) {
        ListUtils.replace(this.instructions, instruction);
      } else {
        this.instructions.add(instruction);
      }
      sortInstructions();
    }
  }
  bool containsInstruction(Instruction instruction) {
    if(instruction != null) {
      return this.instructions.contains(instruction);
    }
    return false;
  }

  IngredientFactory get _ingredientFactory {
    return factoryLocator.getFactory<IngredientFactory>();
  }

  InstructionFactory get _instructionFactory {
    return factoryLocator.getFactory<InstructionFactory>();
  }


  void sortInstructions() {
    this.instructions.sort((a, b) {
      if(b.order == null)
        return 1;
      if(a.order == null)
        return -1;
      return a.order.compareTo(b.order);
    });
  }

  void lazyLoad(Recipe fullRecipe) {
    if(fullRecipe != null) {
      this.ingredients = fullRecipe.ingredients;
      this.instructions = fullRecipe.instructions;
    }
  }

  void resetNbPersons() {
    if(NumberUtils.intIsNotBlank(this.nbPersons) && this.ingredients != null && this.ingredients.length > 0) {
      for(Ingredient ingredient in ingredients) {
        if(ingredient.quantity != null) {
          ingredient.modifiedQuantity = ingredient.quantity;
          if(ingredient.maxQuantity != null) {
            ingredient.modifiedMaxQuantity = ingredient.maxQuantity;
          }
        }
      }
    }
  }

  void changeNbPersons(int nbPersons) {
    if(NumberUtils.intIsNotBlank(this.nbPersons) && NumberUtils.intIsNotBlank(nbPersons) && this.ingredients != null && this.ingredients.length > 0) {
      double multiplication = nbPersons / this.nbPersons;

      for(Ingredient ingredient in ingredients) {
        if(ingredient.quantity != null) {
          ingredient.modifiedQuantity = NumberUtils.roundDouble(ingredient.quantity * multiplication, 2);
          if(ingredient.maxQuantity != null) {
            ingredient.modifiedMaxQuantity = NumberUtils.roundDouble(ingredient.maxQuantity * multiplication, 2);
          }
        }
      }
    }
  }

  void makeIngredientsModifiedQuantityDefinitive() {
    for(Ingredient ingredient in ingredients) {
      ingredient.quantity = ingredient.modifiedQuantity;
      ingredient.maxQuantity = ingredient.modifiedMaxQuantity;
    }
  }

  bool hasUrl() {
    return this.url != null;
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = toMap();

    List ingredients =
      this.ingredients != null ? this.ingredients.map((i) => i.toJson()).toList() : null;
    List instructions =
      this.instructions != null ? this.instructions.map((i) => i.toJson()).toList() : null;
    
    json['ingredients'] = ingredients;
    json['instructions'] = instructions;

    return json;
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = super.toMap();

    map['url'] = url;
    map['nb_persons'] = nbPersons;

    return map;
  }

  @override
  AbstractModel clone([AbstractModel toClone]) {
    Recipe clone = new Recipe();

    super.clone(clone);
    clone.url = this.url;
    clone.siteType = this.siteType;
    clone.nbPersons = this.nbPersons;
    clone.fromShoppingRecipe = this.fromShoppingRecipe;

    clone.ingredients = this.ingredients.map((ingredient) => ingredient.clone() as Ingredient).toList();
    clone.instructions = this.instructions.map((instruction) => instruction.clone() as Instruction).toList();

    return clone;
  }
}