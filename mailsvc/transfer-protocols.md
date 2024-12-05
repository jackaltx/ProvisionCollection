# Mail tranfer protocols

Let me explain the differences between LMTP (Local Mail Transfer Protocol) and LDA (Local Delivery Agent):

LDA (Local Delivery Agent):
- Used for local mail delivery to user mailboxes
- Typically used with Postfix's local delivery
- Processes one message at a time
- Example: Dovecot's deliver program
- Single delivery attempt - if it fails, the message bounces
- Commonly used in simpler setups

LMTP (Local Mail Transfer Protocol):
- Like SMTP but for local delivery
- Designed for centralized mail stores
- Can handle multiple simultaneous deliveries
- Provides immediate feedback on delivery status
- More efficient for high-volume mail servers
- Better for clustered/distributed setups
- Supports multiple delivery attempts

In your setup:
- LMTP is shown in your Dovecot protocols: `protocols = imap lmtp`
- This means Postfix can hand mail directly to Dovecot for delivery
- More efficient than using LDA, especially for multiple recipients

The main practical difference:
- LDA: Single message, single recipient, one attempt
- LMTP: Multiple messages, multiple recipients, better error handling

