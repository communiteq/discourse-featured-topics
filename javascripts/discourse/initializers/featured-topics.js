import { apiInitializer } from "discourse/lib/api";
import FeaturedTopics from "../components/featured-topics";

export default apiInitializer((api) => {
  api.renderInOutlet(settings.plugin_outlet.trim(), FeaturedTopics);
});
