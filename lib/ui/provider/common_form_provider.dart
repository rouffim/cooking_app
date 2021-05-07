import 'package:cool_cooker/core/model/abstract_model.dart';
import 'package:cool_cooker/core/service/api/common_service.dart';
import 'package:cool_cooker/core/service/service_locator_setup.dart';
import 'package:cool_cooker/utils/string_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

abstract class CommonFormProvider<S extends CommonService, T extends AbstractModel> extends ChangeNotifier {
  T formItem;
  AbstractModel relatedFkFormItem;
  GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();
  Map<String, TextEditingController> controllerMap = new Map();
  bool isReady = false;


  void initForm();

  Future<T> submitForm(BuildContext context);

  void setReady() {
    isReady = true;
    notifyListeners();
  }

  void setNotReady() {
    isReady = false;
    notifyListeners();
  }

  Future<void> setItem(String uuid, [AbstractModel relatedFkFormItem]) async {
    isReady = false;
    this.relatedFkFormItem = relatedFkFormItem;

    if(StringUtils.isNotBlank(uuid)) {
      formItem = await service.findOne(uuid);
    } else {
      formItem = null;
    }

    initForm();

    if(StringUtils.isNotBlank(uuid)) {
      setReady();
    } else {
      isReady = true;
    }
  }

  bool isModification() {
    return formItem != null;
  }

  TextEditingController getController(String field) {
    return controllerMap[field];
  }

  void addController(String field) {
    controllerMap[field] = TextEditingController();
  }

  void deleteField(String field) {
    if(controllerMap.containsKey(field)) {
      controllerMap[field].text = '';
    }
  }

  S get service {
    return serviceLocator.getService<S>();
  }
}