# Pick

### Get pictures attached to a story and order them by `vieworder` (+ a whole lot more!).

For use with [DTI](http://www.dtint.com/)'s [ContentPublisher](http://www.dtint.com/our-solutions/content-publisher/) which is powered by [Intersystem](http://www.intersystems.com/)'s [Caché](http://www.intersystems.com/cache/index.html).

---

#### DETAILS

## RULE/tag

### `<custom:rg:get:pics>` attributes:

1. `story`: A `dt.cms.schema.CMSStory` object or a valid `CMSStory` `ID` (required).
2. `position`: Picture item position (required).
3. `include`: Include only these priorities (comma delimited list).
4. `exclude`: Exclude only these priorities (comma delimited list).
5. `items`: Number of `CMSPicture` objects to return; the default number '`0`', which returns all `CMSPictures`.
6. `order`: Custom `ORDER BY`, used in `SQL` statement.
7. `direction`: Direction of iteration; either `forward` (default) or `backward`.
8. `count`: Loop counter name; the default name is '`count`'.
9. `value`: `CMSPicture` object name; the default name is '`value`'.
10. `obj`: Local `%ListOfObjects` object variable name; the default name is '`obj`'.
11. `total`: Total number of `CMSPicture` objects returned.

## API access

### `##class(custom.rg.Pick).pics()` parameters:

1. `story`: A `dt.cms.schema.CMSStory` object or a valid `CMSStory` `ID` (required).
2. `position`: Picture item position (required).
4. `include`: Include only these priorities (comma delimited list).
5. `exclude`: Exclude only these priorities (comma delimited list).
3. `items`: Number of `CMSPicture` objects to return; the default number '`0`', which returns all `CMSPictures`.
6. `order`: Custom `ORDER BY`, used in `SQL` statement.

---

#### DEMO

Example code can be [found here](https://github.com/registerguard/pick/blob/master/pick/demo.csp) and the demo's generated `HTML` can be [found here](http://registerguard.github.com/pick/).

---

#### LEGAL

Copyright © 2013 [Micky Hulse](http://mky.io)

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this work except in compliance with the License. You may obtain a copy of the License in the LICENSE file, or at:

[http://www.apache.org/licenses/LICENSE-2.0](http://www.apache.org/licenses/LICENSE-2.0)

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
