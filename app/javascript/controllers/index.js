// app/javascript/controllers/index.js

import { application } from "./application"

import DeleteModalController from "./delete_modal_controller.js"
import DropdownController from "./dropdown_controller.js"
import FriendSelectController from "./friend_select_controller.js"

application.register("delete-modal", DeleteModalController)
application.register("dropdown", DropdownController)
application.register("friend-select", FriendSelectController)
