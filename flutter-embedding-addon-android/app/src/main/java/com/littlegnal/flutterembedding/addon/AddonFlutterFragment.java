/*
 * Copyright (C) 2020 littlegnal
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package com.littlegnal.flutterembedding.addon;

import android.content.Context;

import androidx.annotation.NonNull;

import io.flutter.embedding.android.FlutterFragment;
import io.flutter.embedding.android.FlutterView;
import io.flutter.embedding.engine.FlutterEngine;

public class AddonFlutterFragment extends FlutterFragment {
  @Override
  public FlutterEngine provideFlutterEngine(@NonNull Context context) {
    return AddonFlutterEngineManager.getInstance().getFlutterEngine(context);
  }

  @Override
  public boolean shouldDestroyEngineWithHost() {
    return AddonFlutterEngineManager.getInstance().shouldDestroyEngineWithHost();
  }

  @NonNull
  @Override
  public FlutterView.RenderMode getRenderMode() {
    return FlutterView.RenderMode.texture;
  }

  @NonNull
  @Override
  public FlutterView.TransparencyMode getTransparencyMode() {
    return FlutterView.TransparencyMode.transparent;
  }

  @Override
  public void onDetach() {
    AddonFlutterEngineManager.getInstance().inactiveEngine();
    super.onDetach();
  }
}
