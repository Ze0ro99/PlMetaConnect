# Pi Network Integration Guide

## SDK Setup

Include the official Pi SDK in your frontend:

```html
<script src="https://sdk.minepi.com/pi-sdk.js"></script>
<script>Pi.init({ version: "2.0" })</script>
```

## Authentication & Payments

- Use Pi SDK methods for authenticating users and accessing wallet balances.
- Implement User-to-App and App-to-User payment flows with server-side approval/completion.
- Test with the Testnet before switching to Mainnet.

## App Registration

- Register in the Pi Developer Portal (`pi://develop.pi`) for both Mainnet and Testnet.
- Complete the platform’s checklist for hosting, wallet, and permissions.

## More Resources

- [Pi Platform Docs](https://github.com/pi-apps/pi-platform-docs)
- [SDK Reference](https://github.com/pi-apps/pi-platform-docs/blob/master/SDK_reference.md)
- [Payments Guide](https://github.com/pi-apps/pi-platform-docs/blob/master/payments.md)
