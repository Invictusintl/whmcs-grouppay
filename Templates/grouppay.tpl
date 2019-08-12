<script type="application/javascript">
function checkAmt(limit){
    var el = document.getElementsByName('amount');

	if(!(/[0-9]*\.?[0-9]+/.test(el[0].value))){
		alert('Please Enter Valid Amount');
		return false;
	}else{
		if(parseFloat(el[0].value) < parseFloat(limit)){
			alert('Please enter an amount higher than the minimum payment of ' + limit);
			return false;
		}
	}
}
</script>

{if $grouppayActive}
	{* Group Pay is Active *}
	{* REPLACE WITH GENERIC INFO ABOUT GROUP YOU WANT BOTH LOGGED IN CLIENTS AND PAYERS (Loged out clients) TO SEE *}
	{if $fromPayPal}
		{* Screen shown when returning from a paypal transaction *}
		<p>Your payment has been submitted to paypal.<br>You will be emailed a confirmation from PayPal with the details.</p>
	{else}
		{if $loggedin and ! $anotherClientHash}
			{* This is shown to Logged in clients that haven't supplied another client's hash *}
			      <div><h3>How it works</h3>
			<img src="/images/icon/group_pay.svg" alt="Group Pay" class="uk-align-left" width="200"><p>Provide the link below to all of your Clan/Guild/Teammates. When they click on the link they are brought to a special page just for you. They will then have the option of contributing to the cost of your servers. This way everyone can pay for your server instead of just you paying for it yourself.</p>
			<div class="uk-alert"><p>TIP: If your server is overdue on payment and one of your users sends in a Group Pay payment our system will automatically apply the payment and unsuspend the server a few hours after receiving the payment. So make sure your users are aware they can get the server going again.</p></div>
			<p><strong>The minimum payout value for each contribution is $3.00 USD and can only be done through PayPal</strong><br />Please also let your contributors know that there are no refunds for their contributions for any reason.</p><p>If you have a company/group name set in the details section of the client area then that is what will show up. If you don't then your firstname will appear.</p></div>
			Your {$SystemName} hash is: <b>{$loggedInHash}</b><br>
			Your {$SystemName} link is:
            <b>
                <a href="{rtrim($systemurl, '/')}/grouppay.php?hash={$loggedInHash}">
                    {rtrim($systemurl, '/')}/grouppay.php?hash={$loggedInHash}
                </a>
            </b>
            <br>
			<br>

			{* DELETE THE BELOW CODE TO REMOVE PAST PAYMENTS SHOWING FOR LOGGED IN CLIENTS *}

				<h2>Past {$SystemName} Payments</h2>
				<p>Below are payments that have been made to your account from others.{if $hidePublicPayments} These are only shown to you.{/if}</p>

				{if empty($pastPayments)}
					<b>No previous payments found.</b>
				{else}
					<table class="data" style="width:100%">
						<tr><th>Date</th><th>Paid By</th><th>Amount</th></tr>
						{foreach from=$pastPayments key=myId item=pmnt}
							<tr><td>{$pmnt.date}</td><td>{trim($pmnt.description, "() \t\n\r\0\x0B")}</td><td>{$pmnt.amount}</td></tr>
						{/foreach}
					</table>
				{/if}
			{*  DELETE THE ABOVE CODE TO REMOVE PAST PAYMENTS SHOWING FOR LOGGED IN CLIENTS *}

		{else}
			{* This is shown to Payers (clients that are not logged-in or logged-in clients that gave another hash) *}
			{if $clientFound}
				{* Payer Has Provided a valid hash *}
				<div><h3>Welcome! to our Server Funding Page</h3><p>This is our unique page for TserverHQ's Group Pay. It's for paying for our service together so we can all share the cost. Simply enter how much you want to contribute to our server costs below and you will be taken to PayPal to pay it.<br />
			  Your money can only be used for the server and nothing else.</p><p>Thanks again for contributing.<br><strong>{if !empty($clientInfo->company)} ({$clientInfo->company}){else}{$clientInfo->firstname}{/if}</strong></p></div>
				<hr class="dotted" />
				<b>Client Hash:</b> {$clientHash}<br>
				<b>Client Name:</b> {if !empty($clientInfo->company)} ({$clientInfo->company}){else}{$clientInfo->firstname} {$clientInfo->lastname}{/if}<br>
				<b>Minimum Payment:</b> {formatCurrency($minPayment)}<br>

                <form id="paypalForm" action="{$payPalUrl}" onsubmit="return checkAmt({$minPayment})" method="post">
                    <input type="hidden" name="cmd" value="_xclick">
                    <input type="hidden" name="custom" value="{$clientHash}">
                    <input type="hidden" name="no_note" value="1">
                    <input type="hidden" name="item_name" value="{$companyname} - {$SystemName} - {if !empty($clientInfo->company)} ({$clientInfo->company}){else}{$clientInfo->firstname} {$clientInfo->lastname}{/if}">
                    <input type="hidden" name="currency_code" value="{$currency.code}">
                    <input type="hidden" name="return" value="{rtrim($systemurl, '/')}/grouppay.php?fromPaypal=true">
                    <input type="hidden" name="cancel_return" value="{rtrim($systemurl, '/')}/grouppay.php?hash={$clientHash}">
                    <input type="hidden" name="notify_url" value="{rtrim($systemurl, '/')}/modules/addons/group_pay/grouppay_callback.php">
                    <input type="hidden" name="no_shipping" value="1">
                    <input type="hidden" name="business" value="{$gpPayPalEmail}">
                    <b>Payment Amount:</b> <input type="text" title="amount" name="amount"/><br>
										<div class="box-warning"><strong>There are <span style="color:red;">NO</span> refunds for any Group Pay payments.</strong></div>
                    <input type="image" class="gppaypalimage" style="height:40px; width:145px; border:none; margin-top: 16px" src="https://www.paypalobjects.com/en_US/i/btn/btn_xpressCheckout.gif" border="0" name="submit" alt="Make payments with PayPal - it's fast, free and secure!">
                </form>

				{if ! $hidePublicPayments}

					<h2>Past {$SystemName} Payments</h2>
					<p>Below are payments that have been made to this client's {$SystemName}.</p>
					<table class="data" style="width:100%">
						<tr><th>Date</th><th>Description</th><th>Amount</th></tr>
						{foreach from=$pastPayments key=myId item=pmnt}
							<tr><td>{$pmnt.date}</td><td>{$pmnt.description}</td><td>{$pmnt.amount}</td></tr>
						{/foreach}
					</table>

				{/if}

			{else}
				{* Payer Has Provided an invalid hash *}
				<div style="text-align:center;" class="box-content"><div class="box-warning"><strong>You have used a bad group pay link, or a bad client hash.</strong></div><hr class="dotted" />If you were given a customized URL to help pay for your group's server costs the owner of the account didn't provide the correct link!
				<strong>Please contact the person that gave you the link so they can check the value.</strong></div>
			{/if}
		{/if}
	{/if}
{else}
	{* Group Pay is Inactive *}
	{* NOTE: If your license is invalid the system is forced into disabled mode *}
	<p>The group pay system is currently not enabled.<br>Please contact support for more info.</p>
{/if}
