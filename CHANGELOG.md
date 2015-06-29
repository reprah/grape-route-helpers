# Changelog

## June 28 2015

Release 1.0.1

* Rename rake task from `grape:routes` to `grape:route_helpers`

* If a Grape::Route has a specific format (json, etc.) in its route_path attribute, the helper will return a path with this extension at the end
