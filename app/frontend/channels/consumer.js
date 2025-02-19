import { createConsumer } from "@rails/actioncable";

export default createConsumer("ws://localhost:5100/cable");